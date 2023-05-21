//	Created by Leopold Lemmermann on 23.11.22.

import BaseTests

final class MockKeyValueStorageServiceTests: KeyValueStorageServiceTests<MockKeyValueStorageService<String>> {
  override func setUp() {
    service = .init()
    service.deleteAll()
  }
}
