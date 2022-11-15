//	Created by Leopold Lemmermann on 15.11.22.

@testable import UserDefaultsStorageService
import XCTest

final class UserDefaultsStorageServiceTests: BaseTests {
  override func setUpWithError() throws {
    service = UserDefaultsStorageService()
    service.deleteAll()
  }
}
