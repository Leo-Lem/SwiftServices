// Created by Leopold Lemmermann on 01.06.23.

import AssociationServiceTests
@testable import KeychainService

final class KeychainServiceTests: AssociationServiceTests<KeychainService> {
  override func injectService() async throws -> KeychainService {
    KeychainService(valueClass: .genericPassword)
  }

  override func testStoringAndLoading_givenItemHasBeenStored_whenLoadingForKey_thenReturnsItem() async throws {
    throw XCTSkip("Keychain storage only works for data.")
  }

  override func testDeleting_givenItemExists_whenDeleting_thenCannotBeLoadedAgain() async throws {
    throw XCTSkip("Keychain storage only works for data")
  }

  override func testStoringAndLoadingCodable_givenAStoredCodable_whenLoadingObjectForKey_thenReturnsObject() async throws {
    throw XCTSkip("Keychain returns -34018 in unit tests, can't be accessed, but it works in an app.")
  }

  override func testDeletingAll_givenMultipleStoredItems_whenDeletingAll_thenClearsStorage() async throws {
    let (key1, key2, item1, item2) = ("item1", "item2", "HELLO", "WORLD")

    try service.store(object: item1, for: key1)
    try service.store(object: item2, for: key2)
    service.deleteAll()

    XCTAssertNil(try service.load(objectFor: key1) as String?, "The item was not deleted.")
    XCTAssertNil(try service.load(objectFor: key2) as String?, "The item was not deleted.")
  }
}
