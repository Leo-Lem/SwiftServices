import BaseTests

class AnyInAppPurchaseServiceTests: InAppPurchaseServiceTests<AnyInAppPurchaseService<ExamplePurchaseID>> {
  override func setUp() async throws { service = .mock }
}
