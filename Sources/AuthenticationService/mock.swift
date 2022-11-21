//	Created by Leopold Lemmermann on 21.10.22.

final class MockAuthenticationService: AuthenticationService {
  var status: AuthenticationStatus = .notAuthenticated

  @discardableResult
  func login(_ credential: Credential) async throws -> Credential {
    status = .authenticated(credential)
    print("Logged user in with \(credential).")
    return credential
  }
  
  @discardableResult
  func changePIN(_ newPIN: String) async throws -> Credential {
    guard case let .authenticated(credential) = status else {
      throw AuthenticationError.notAuthenticated
    }
    let newCredential = Credential(id: credential.id, pin: newPIN)
    status = .authenticated(newCredential)
    print("Changed pin \(credential).")
    return newCredential
  }
  
  func deregister() async throws {
    guard case let .authenticated(credential) = status else {
      throw AuthenticationError.notAuthenticated
    }
    status = .notAuthenticated
    print("Deregistered user with \(credential).")
  }
  
  func logout() {
    status = .notAuthenticated
    print("Logged user out.")
  }
}
