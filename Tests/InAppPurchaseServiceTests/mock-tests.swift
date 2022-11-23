//	Created by Leopold Lemmermann on 23.11.22.

import InAppPurchaseService

@available(iOS 15, macOS 12, *)
class MockInAppPurchaseServiceTests: InAppPurchaseServiceTests<MockInAppPurchaseService<ExamplePurchaseID>> {
  override func setUp() async throws {
    service = .init()
  }
}
