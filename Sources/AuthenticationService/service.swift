
public protocol AuthenticationService {
  var status: AuthenticationStatus { get }

  @discardableResult
  func login(_ credential: Credential) async throws -> Credential
  
  @discardableResult
  func changePIN(_ newPIN: String) async throws -> Credential
  
  func deregister() async throws
  
  func logout() throws
}
