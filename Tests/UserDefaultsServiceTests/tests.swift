//	Created by Leopold Lemmermann on 15.11.22.

@testable import UserDefaultsService
import BaseTests

final class UserDefaultsServiceTests: KeyValueStorageServiceTests<UserDefaultsService<String>> {
  override func setUp() {
    service = .init()
    service.deleteAll()
  }
}
