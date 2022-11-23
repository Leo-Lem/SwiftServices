@testable import StoreKitService
import InAppPurchaseServiceTests
import XCTest

// FIXME: Need to create a storekit mock in the service or get the products file working
@available(iOS 15, macOS 12, *)
class StoreKitServiceTests: InAppPurchaseServiceTests<StoreKitService<ExamplePurchaseID>> {
  override func setUp() async throws {
    service = await .init()
    
    if service.getPurchases(isPurchased: false).isEmpty {
      throw XCTSkip("There are no purchases available.")
    }
  }
}
