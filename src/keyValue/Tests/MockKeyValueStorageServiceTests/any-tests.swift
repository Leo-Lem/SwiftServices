//	Created by Leopold Lemmermann on 03.12.22.

import BaseTests

final class AnyKeyValueStorageServiceTests: KeyValueStorageServiceTests<AnyKeyValueStorageService<String>> {
  override func setUp() {
    service = .mock
    service.deleteAll()
  }
}
