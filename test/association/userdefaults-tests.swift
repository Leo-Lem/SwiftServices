//	Created by Leopold Lemmermann on 15.11.22.

final class UserDefaultsServiceTests: AssociationServiceTests<UserDefaultsService> {
  override func injectService() async throws -> UserDefaultsService { UserDefaultsService() }
}
