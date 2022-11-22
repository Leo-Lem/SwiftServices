
import Combine

public protocol AuthenticationService {
  var didChange: PassthroughSubject<AuthenticationStatus, Never> { get }
  
  var status: AuthenticationStatus { get }

  @discardableResult
  func login(_ credential: Credential) async throws -> Credential.ID
  
  @discardableResult
  func changePIN(_ newPIN: Credential.PIN) async throws -> Credential.ID
  
  func deregister() async throws
  
  func logout() throws
}
