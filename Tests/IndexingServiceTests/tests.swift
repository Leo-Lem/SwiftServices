@testable import IndexingService
import XCTest

// !!!:  Subclass these tests and insert an implementation in the setUp method.
open class IndexingServiceTests<T: Example>: XCTestCase {
  public var service: IndexingService!
  
  func testInserting() async throws {
    let example = T.example
    try await service.updateReference(to: example)
  }
  
  func testDeleting() async throws {
    let example = T.example
    try await service.updateReference(to: example)
    try await service.removeReference(with: example.id.uuidString)
  }
}
