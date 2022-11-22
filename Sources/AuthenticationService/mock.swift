//	Created by Leopold Lemmermann on 21.10.22.

import Combine

open class MockAuthenticationService: AuthenticationService {
  public var didChange = PassthroughSubject<AuthenticationStatus, Never>()
  
  public var status: AuthenticationStatus = .notAuthenticated {
    didSet { didChange.send(status) }
  }

  @discardableResult
  public func login(_ credential: Credential) async throws -> Credential {
    status = .authenticated(credential)
    print("Logged user in with \(credential).")
    return credential
  }
  
  @discardableResult
  public func changePIN(_ newPIN: String) async throws -> Credential {
    guard case let .authenticated(credential) = status else {
      throw AuthenticationError.notAuthenticated
    }
    let newCredential = Credential(id: credential.id, pin: newPIN)
    status = .authenticated(newCredential)
    print("Changed pin \(credential).")
    return newCredential
  }
  
  public func deregister() async throws {
    guard case let .authenticated(credential) = status else {
      throw AuthenticationError.notAuthenticated
    }
    status = .notAuthenticated
    print("Deregistered user with \(credential).")
  }
  
  public func logout() {
    status = .notAuthenticated
    print("Logged user out.")
  }
}
