import BaseTests

@available(iOS 16, macOS 13, *)
final class MockAuthenticationServiceTests: BaseTests<Any> {
  override func setUp() async throws { service = .mock }
}
