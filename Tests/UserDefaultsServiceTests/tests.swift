//	Created by Leopold Lemmermann on 15.11.22.

@testable import UserDefaultsService
import KeyValueStorageServiceTests

class UserDefaultsServiceTests: KeyValueStorageServiceTests {
  override func setUpWithError() throws {
    service = UserDefaultsService()
    service.deleteAll()
  }
}

