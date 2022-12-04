@_exported @testable import IndexingService
@_exported import XCTest

// !!!:  Subclass these tests and insert an implementation in the setUp method.
open class BaseTests<S: IndexingService, T: Example>: XCTestCase {
  public var service: S!
  
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
