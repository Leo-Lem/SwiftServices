import BaseTests

class MockInAppPurchaseServiceTests: InAppPurchaseServiceTests<MockInAppPurchaseService<ExamplePurchaseID>> {
  override func setUp() async throws { service = .init() }
}
