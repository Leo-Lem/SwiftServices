@testable import StoreKitService
import InAppPurchaseServiceTests
import XCTest

// TODO: mock storekit in the service, to enable testing.

@available(iOS 15, macOS 12, *)
class StoreKitServiceTests: InAppPurchaseServiceTests {
  override func setUp() async throws {
    service = await StoreKitService<ExamplePurchaseID>()
    
    if service.getPurchases(isPurchased: false).isEmpty {
      throw XCTSkip("There are no purchases available.")
    }
  }
}
