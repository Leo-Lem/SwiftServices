@testable import IndexingService
import XCTest

open class IndexingServiceTests: XCTestCase {
  public var service: IndexingService!

  open override func setUpWithError() throws {
    try XCTSkipIf(
      service == nil,
      "Subclass these IndexingServiceTests and assign an instance of CoreSpotlightService to 'service' in the setUpWithError!"
    )
  }
}
