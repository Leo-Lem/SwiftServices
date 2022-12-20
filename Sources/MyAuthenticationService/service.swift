@_exported import AuthenticationService
import Errors
import struct Foundation.URL
import UserDefaultsService

open class MyAuthenticationService: AuthenticationService {
  public var eventPublisher = Publisher<AuthenticationEvent>()

  public var status: AuthenticationStatus = .notAuthenticated

  internal let server: URL
  internal let keyValueStorageService: AnyKeyValueStorageService<String>

  public init(
    server: URL,
    keyValueStorageService: AnyKeyValueStorageService<String> = .userDefaults()
  ) {
    self.server = server
    self.keyValueStorageService = keyValueStorageService

    Task {
      await printError {
        if let credential = loadCredential() { try await login(credential) }
      }
    }
  }

  public func exists(_ id: Credential.ID) async throws -> Bool {
    let (response, _) = try await callAPI(.exists, data: id)

    switch response?.statusCode {
    case 200:
      return true
    case 404:
      return false
    case .none:
      throw AuthenticationError.noConnection
    case let .some(code):
      throw AuthenticationError.unexpected(status: code)
    }
  }

  @discardableResult public func register(_ credential: Credential) async throws -> Credential.ID {
    let (response, data) = try await callAPI(.register, data: credential)

    switch response?.statusCode {
    case 200:
      let id = performLogin(try Credential(from: data))
      eventPublisher.send(.registered)
      return id
    case 400:
      throw AuthenticationError.registrationInvalidID(credential.id)
    case 409:
      throw AuthenticationError.registrationIDTaken(credential.id)
    case .none:
      throw AuthenticationError.noConnection
    case let .some(code):
      throw AuthenticationError.unexpected(status: code)
    }
  }

  @discardableResult public func login(_ credential: Credential) async throws -> Credential.ID {
    let (response, data) = try await callAPI(.login, data: credential)

    switch response?.statusCode {
    case 200:
      let id = performLogin(try Credential(from: data))
      eventPublisher.send(.loggedIn)
      return id
    case 401:
      throw AuthenticationError.authenticationWrongPIN
    case 404:
      throw AuthenticationError.authenticationUnknownID(credential.id)
    case .none:
      throw AuthenticationError.noConnection
    case let .some(code):
      throw AuthenticationError.unexpected(status: code)
    }
  }

  @discardableResult public func changePIN(_ newPIN: Credential.PIN) async throws -> Credential.ID {
    let (response, data) = try await callAPI(.changePIN, data: try loadCurrentCredential().attachNewPIN(newPIN))

    switch response?.statusCode {
    case 200:
      let id = performLogin(try Credential(from: data))
      eventPublisher.send(.changedPin)
      return id
    case .none:
      throw AuthenticationError.noConnection
    case let .some(code):
      throw AuthenticationError.unexpected(status: code)
    }
  }

  public func deregister() async throws {
    let credential = try loadCurrentCredential()
    let (response, _) = try await callAPI(.deregister, data: credential)

    switch response?.statusCode {
    case 200:
      eventPublisher.send(.deregistered)
      performLogout(credential.id)
    case .none:
      throw AuthenticationError.noConnection
    case let .some(code):
      throw AuthenticationError.unexpected(status: code)
    }
  }

  public func logout() throws {
    guard case let .authenticated(id) = status else { throw AuthenticationError.notAuthenticated }
    
    performLogout(id)
    eventPublisher.send(.loggedOut)
  }
}
