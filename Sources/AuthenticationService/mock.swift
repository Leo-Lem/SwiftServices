//	Created by Leopold Lemmermann on 21.10.22.

import Combine

open class MockAuthenticationService: AuthenticationService {
  public var didChange = PassthroughSubject<AuthenticationStatus, Never>()
  
  public var status: AuthenticationStatus = .notAuthenticated {
    didSet { didChange.send(status) }
  }
  
  public init() {}

  @discardableResult
  public func login(_ credential: Credential) async throws -> Credential.ID {
    status = .authenticated(credential.id)
    print("Logged user in with \(credential).")
    return credential.id
  }
  
  @discardableResult
  public func changePIN(_ newPIN: Credential.PIN) async throws -> Credential.ID {
    guard case let .authenticated(id) = status else { throw AuthenticationError.notAuthenticated }
    let credential = Credential(id: id, pin: newPIN)
    status = .authenticated(credential.id)
    print("Changed pin with \(id).")
    return credential.id
  }
  
  public func deregister() async throws {
    guard case let .authenticated(id) = status else { throw AuthenticationError.notAuthenticated }
    status = .notAuthenticated
    print("Deregistered user with \(id).")
  }
  
  public func logout() {
    status = .notAuthenticated
    print("Logged user out.")
  }
}
