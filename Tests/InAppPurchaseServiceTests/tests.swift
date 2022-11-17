@testable import InAppPurchaseService
import XCTest

open class InAppPurchaseServiceTests: XCTestCase {
  public var service: InAppPurchaseService!

  open override func setUpWithError() throws {
    try XCTSkipIf(
      service == nil,
      "Subclass these InAppPurchaseServiceTests and assign an instance of StoreKitService to 'service' in the setUpWithError!"
    )
  }
}
