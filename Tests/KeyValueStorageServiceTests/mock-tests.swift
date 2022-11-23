//	Created by Leopold Lemmermann on 23.11.22.

import KeyValueStorageService

class MockKeyValueStorageServiceTests: KeyValueStorageServiceTests<Any> {
  override func setUpWithError() throws {
    service = MockKeyValueStorageService()
    service.deleteAll()
  }
}
