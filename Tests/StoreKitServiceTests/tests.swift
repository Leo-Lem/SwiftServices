@testable import StoreKitService
import InAppPurchaseServiceTests

class StoreKitServiceTests: InAppPurchaseServiceTests {
  override func setUpWithError() throws {
    service = StoreKitService()
  }
}
