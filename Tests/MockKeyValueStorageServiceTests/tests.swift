//	Created by Leopold Lemmermann on 23.11.22.

import BaseTests

final class MockKeyValueStorageServiceTests: KeyValueStorageServiceTests<MockKeyValueStorageService> {
  override func setUpWithError() throws {
    service = .init()
    service.deleteAll()
  }
}
