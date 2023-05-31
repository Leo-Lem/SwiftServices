import BaseTests

final class MockAuthenticationServiceTests: BaseTests<MockAuthenticationService> {
  override func setUp() async throws {
    service = .init()
    
  }
}
