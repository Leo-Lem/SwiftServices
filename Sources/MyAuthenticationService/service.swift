
import AuthenticationService
import Combine
import Foundation
import KeyValueStorageService
import UserDefaultsService

open class MyAuthenticationService: AuthenticationService {
  public var didChange = PassthroughSubject<AuthenticationStatus, Never>()

  public var status: AuthenticationStatus = .notAuthenticated {
    didSet { didChange.send(status) }
  }

  internal let baseURL: URL

  internal let keyValueStorageService: KeyValueStorageService

  public init(
    apiURL: String = "https://auth.leolem.dev",
    keyValueStorageService: KeyValueStorageService = UserDefaultsService()
  ) async {
    baseURL = URL(string: apiURL)!
    self.keyValueStorageService = keyValueStorageService

    if let credential = loadCredential() {
      _ = try? await login(credential)
    }
  }

  @discardableResult
  public func login(_ credential: Credential) async throws -> Credential.ID {
    try await mapError {
      var (data, response) = try await callAPI(.auth, method: .PUT, data: credential)

      switch response?.statusCode {
      case 200: break
      case 401: throw AuthenticationError.authenticationWrongPIN
      case 404:
        (data, response) = try await callAPI(.reg, method: .POST, data: credential)

        switch response?.statusCode {
        case 200: break
        case 400: throw AuthenticationError.registrationInvalidID
        case 409: throw AuthenticationError.registrationIDTaken
        case .none: throw AuthenticationError.noConnection
        case let .some(code): throw AuthenticationError.unexpected(status: code)
        }
      case .none: throw AuthenticationError.noConnection
      case let .some(code): throw AuthenticationError.unexpected(status: code)
      }

      let credential = try JSONDecoder().decode(Credential.self, from: data)
      saveCredential(credential)
      status = .authenticated(credential.id)
      return credential.id
    }
  }

  @discardableResult
  public func changePIN(_ newPIN: Credential.PIN) async throws -> Credential.ID {
    try await mapError {
      var credential = try loadCurrentCredential()

      let (data, response) = try await callAPI(
        .pin,
        method: .POST,
        data: credential.attachNewPIN(newPIN)
      )
      switch response?.statusCode {
      case 200: break
      case 400: throw AuthenticationError.modificationInvalidNewPIN
      case .none: throw AuthenticationError.noConnection
      case let .some(code): throw AuthenticationError.unexpected(status: code)
      }

      credential = try JSONDecoder().decode(Credential.self, from: data)
      saveCredential(credential)
      status = .authenticated(credential.id)
      return credential.id
    }
  }

  public func deregister() async throws {
    try await mapError {
      let credential = try loadCurrentCredential()
      let (_, response) = try await callAPI(.dereg, method: .POST, data: credential)

      switch response?.statusCode {
      case 200:
        break
      case .none:
        throw AuthenticationError.noConnection
      case let .some(code):
        throw AuthenticationError.unexpected(status: code)
      }

      try logout()
    }
  }

  public func logout() throws {
    guard case let .authenticated(id) = status else { throw AuthenticationError.notAuthenticated }
    deleteCredential(userID: id)
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
