
import AuthenticationService
import Foundation

open class LLAuthenticationService: AuthenticationService {
  public var status: AuthenticationStatus

  internal let baseURL: URL

  public init(apiURL: String = "https://auth.leolem.dev") async {
    baseURL = URL(string: apiURL)!

    // TODO: persist credential on login and automatically login on restart

    status = .notAuthenticated
  }

  @discardableResult
  public func changePIN(_ newPIN: String) async throws -> Credential {
    guard case let .authenticated(credential) = status else {
      throw AuthenticationError.notAuthenticated
    }
    
    let code: Int?
    let returnCredential: Credential

    do {
      let (data, response) = try await callAPI(.pin, method: .POST, data: credential.attachNewPIN(newPIN))
      code = response?.statusCode
      returnCredential = try JSONDecoder().decode(Credential.self, from: data)
    } catch {
      throw AuthenticationError.other(error)
    }
    
    switch code {
    case 200: break
    case 400: throw AuthenticationError.modificationInvalidNewPIN
    case .none: throw AuthenticationError.noConnection
    case let .some(code): throw AuthenticationError.unexpected(status: code)
    }

    status = .authenticated(returnCredential)
    return returnCredential
  }

  @discardableResult
  public func login(_ credential: Credential) async throws -> Credential {
    do {
      var (data, response) = try await callAPI(.auth, method: .PUT, data: credential)
      
      switch response?.statusCode {
      case 200:
        break
      case 401:
        throw AuthenticationError.authenticationWrongPIN
      case 404:
        (data, response) = try await callAPI(.reg, method: .POST, data: credential)

        switch response?.statusCode {
        case 200: break
        case 400: throw AuthenticationError.registrationInvalidID
        case 409: throw AuthenticationError.registrationIDTaken
        case .none: throw AuthenticationError.noConnection
        case let .some(code): throw AuthenticationError.unexpected(status: code)
        }
      case .none:
        throw AuthenticationError.noConnection
      case let .some(code):
        throw AuthenticationError.unexpected(status: code)
      }
      
      let returnCredential = try JSONDecoder().decode(Credential.self, from: data)

      status = .authenticated(returnCredential)
      return returnCredential
    } catch {
      throw AuthenticationError.other(error)
    }
  }
  
  public func deregister() async throws {
    guard case let .authenticated(credential) = status else {
      throw AuthenticationError.notAuthenticated
    }
    
    switch try? await callAPI(.dereg, method: .POST, data: credential).1?.statusCode {
    case 200:
      break
    case .none:
      throw AuthenticationError.noConnection
    case let .some(code):
      throw AuthenticationError.unexpected(status: code)
    }

    status = .notAuthenticated
  }

  public func logout() throws {
    guard case .authenticated = status else { throw AuthenticationError.notAuthenticated }
    status = .notAuthenticated
  }
  
  #if DEBUG
  public func clear() async {
    var request = URLRequest(url: baseURL)
    
    request.httpMethod = HTTPMethod.DELETE.rawValue
    
    do {
      _ = try await URLSession.shared.data(for: request)
    } catch { print(error.localizedDescription) }
  }
  #endif
}
