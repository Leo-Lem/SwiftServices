@_exported @testable import PurchaseService
@_exported import XCTest

// !!!:  Subclass these tests and insert an implementation to 'service' in the setUp method.
open class InAppPurchaseServiceTests<S: InAppPurchaseService>: XCTestCase where S.PurchaseID == ExamplePurchaseID {
  public var service: S!

  func testGettingPurchases() throws {
    let purchase = service.getPurchase(with: .fullVersion)
    XCTAssertEqual(purchase?.id, .fullVersion, "The purchase id doesn't match.")
  }

  func testGettingPurchase() throws {
    let purchases = service.getPurchases()
    XCTAssertFalse(purchases.isEmpty, "No purchases could be found.")
    
    let purchased = service.getPurchases(isPurchasedOnly: true)
    XCTAssertTrue(purchased.isEmpty, "Some items were purchased already...")
  }

  func testCheckingIfPurchased() throws {
    let isPurchased = service.isPurchased(with: .fullVersion)
    XCTAssertEqual(isPurchased, false, "The purchase is already purchased.")
  }

  func testPurchasing() async throws {
    let result = try await service.purchase(with: .fullVersion)
    XCTAssertEqual(result, .success, "The purchase failed.")
  }
}
