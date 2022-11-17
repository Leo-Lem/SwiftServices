@testable import LLAuthenticationService
import AuthenticationServiceTests

class LLAuthenticationServiceTests: AuthenticationServiceTests {
  override func setUpWithError() throws {
    service = LLAuthenticationService()
  }
}
