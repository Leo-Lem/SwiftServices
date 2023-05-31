//	Created by Leopold Lemmermann on 10.11.22.

@_exported @testable import AssociationService
@_exported import XCTest

// !!!: Subclass these tests and insert an implementation in the setUp method.
open class KeyValueStorageServiceTests<S: AssociationService>: XCTestCase where S.Key == String {
  public var service: S!

  func testStoringAndLoading() throws {
    let (key, item) = ("item", "HELLO")

    service.store(item, for: key)

    XCTAssertEqual(service.load(for: key), item, "The loaded item does not match the stored item.")
  }

  func testDeletingItem() throws {
    let (key, item) = ("item", "HELLO")

    service.store(item, for: key)
    service.delete(for: key)

    XCTAssertNil(service.load(for: key) as String?, "The item was not deleted.")
  }

  func testSecureStoringAndLoading() throws {
    let (key, item) = ("item", "HELLO")

    try service.store(object: item, for: key, securely: true)

    // FIXME: Keychain returns -34018 in unit tests, can't be accessed, but it works in an app.
//    XCTAssertEqual(
//      try service.load(objectFor: key, securely: true), item,
//      "The loaded item does not match the stored item."
//    )
  }

  func testSecureDeletingItem() throws {
    let (key, item) = ("item", "HELLO")

    try service.store(object: item, for: key, securely: true)
    service.delete(for: key, securely: true)

    XCTAssertNil(try service.load(objectFor: key, securely: true) as String?, "The item was not deleted.")
  }
}
