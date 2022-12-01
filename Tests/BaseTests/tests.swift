//	Created by Leopold Lemmermann on 10.11.22.

@_exported @testable import KeyValueStorageService
@_exported import XCTest

// !!!:  Subclass these tests and insert an implementation in the setUp method.
// (see mock-tests for example)
open class KeyValueStorageServiceTests<S: KeyValueStorageService>: XCTestCase {
  public var service: S!
  
  func testStoringAndLoading() throws {
    let item = "HELLO",
        key = "item"
    
    service.store(item, for: key)
    
    XCTAssertEqual(service.load(for: key), item, "The loaded item does not match the stored item.")
  }
  
  func testDeletingItem() throws {
    let item = "HELLO",
        key = "item"
    
    service.store(item, for: key)
    
    service.delete(for: key)
    
    XCTAssertNil(service.load(for: key) as String?, "The item was not deleted.")
  }
}
