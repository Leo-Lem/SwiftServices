@testable import InAppPurchaseService
import XCTest

open class InAppPurchaseServiceTests: XCTestCase {
  public var service: (any InAppPurchaseService)!

  override open func setUpWithError() throws {
    try XCTSkipIf(
      service == nil,
      "Subclass these InAppPurchaseServiceTests and assign an instance of StoreKitService to 'service' in the setUpWithError!"
    )
  }

  func testGettingPurchases() throws {}

  func testGettingIDs() throws {}

  func testGettingPurchase() throws {}

  func testCheckingIfPurchased() throws {}

  func testPurchasing() throws {}
}
