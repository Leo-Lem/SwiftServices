//	Created by Leopold Lemmermann on 15.11.22.

@testable import UserDefaultsService
import AssociationServiceTests

final class UserDefaultsServiceTests: AssociationServiceTests<UserDefaultsService> {
  override func injectService() async throws -> UserDefaultsService { UserDefaultsService() }
}
