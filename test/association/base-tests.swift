//  Created by Leopold Lemmermann on 10.11.22.

@_exported import AssociationService
@_exported import XCTest

open class AssociationServiceTests<S: AssociationService>: XCTestCase {
  public var service: S!

  override public func setUp() async throws {
    service = try await injectService()
    service.deleteAll()
  }

  open func injectService() async throws -> S {
    fatalError("You must override the injectService method and inject a service instance…")
  }

  open func testStoringAndLoading_givenItemHasBeenStored_whenLoadingForKey_thenReturnsItem() async throws {
    let (key, item) = ("item", "HELLO")

    service.store(item, for: key)

    XCTAssertEqual(service.load(for: key), item, "The loaded item does not match the stored item.")
  }

  open func testDeleting_givenItemExists_whenDeleting_thenCannotBeLoadedAgain() async throws {
    let (key, item) = ("item", "HELLO")

    service.store(item, for: key)
    service.delete(for: key)

    XCTAssertNil(service.load(for: key) as String?, "The item was not deleted.")
  }

  open func testStoringAndLoadingCodable_givenAStoredCodable_whenLoadingObjectForKey_thenReturnsObject() async throws {
    let (key, item) = ("item", "HELLO")

    try service.store(object: item, for: key)

    XCTAssertEqual(try service.load(objectFor: key), item, "The loaded item does not match the stored item.")
  }

  open func testDeletingCodable_givenCodableIsStored_whenDeletingForKey_thenIsDeleted() async throws {
    let (key, item) = ("item", "HELLO")

    try service.store(object: item, for: key)
    service.delete(for: key)

    XCTAssertNil(try service.load(objectFor: key) as String?, "The item was not deleted.")
  }

  open func testDeletingAll_givenMultipleStoredItems_whenDeletingAll_thenClearsStorage() async throws {
    let (key1, key2, item1, item2) = ("item1", "item2", "HELLO", "WORLD")

    service.store(item1, for: key1)
    try service.store(object: item2, for: key2)
    service.deleteAll()

    XCTAssertNil(service.load(for: key1) as String?, "The item was not deleted.")
    XCTAssertNil(try service.load(objectFor: key2) as String?, "The item was not deleted.")
  }
}
