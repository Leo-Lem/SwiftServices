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
  
  func testInserting() async throws {
    let example = Example(title: "Some title", details: "Some details")
    try await service.updateReference(to: example)
  }
  
  func testDeleting() async throws {
    let example = Example(title: "Some title", details: "Some details")
    try await service.updateReference(to: example)
    try await service.removeReference(with: example.id.uuidString)
  }
}
