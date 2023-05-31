@testable import StoreKitService
import BaseTests

// FIXME: Need to create a storekit mock in the service or get the products file working.
@available(iOS 15, macOS 12, *)
class StoreKitServiceTests: InAppPurchaseServiceTests<StoreKitService<ExamplePurchaseID>> {
  override func setUp() async throws {
    service = .init()
    
    if service.getPurchases().isEmpty { throw XCTSkip("There are no purchases available.") }
  }
}
