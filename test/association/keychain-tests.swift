// Created by Leopold Lemmermann on 01.06.23.

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
    throw XCTSkip("Haven't figured out how realiably integration test with the Keychain Services API.")
  }
}
