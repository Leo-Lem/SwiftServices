//	Created by Leopold Lemmermann on 15.11.22.

@testable import UserDefaultsService
import BaseTests

final class UserDefaultsServiceTests: KeyValueStorageServiceTests<UserDefaultsService> {
  override func setUpWithError() throws {
    service = .init()
    service.deleteAll()
  }
}
