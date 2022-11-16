@testable import HapticsService
import XCTest

open class HapticsServiceTests: XCTestCase {
  public var service: HapticsService!

  open override func setUpWithError() throws {
    try XCTSkipIf(
      service == nil,
      "Subclass these HapticsServiceTests and assign an instance of CoreHapticsService to service in the setUpWithError!"
    )
  }
}
