//	Created by Leopold Lemmermann on 23.11.22.

import AuthenticationService

class MockAuthenticationServiceTests: AuthenticationServiceTests<Any> {
  override func setUp() async throws {
    service = MockAuthenticationService()
  }
}
