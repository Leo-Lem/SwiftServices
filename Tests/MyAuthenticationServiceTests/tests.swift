import BaseTests
@testable import MyAuthenticationService

// !!!: These tests make calls to the production api and try to login with an example credential
class MyAuthenticationServiceTests: BaseTests<Any> {
  override func setUp() async throws {
    service = await MyAuthenticationService(
      url: URL(string: "https://github-repo-j3opzjp32q-lz.a.run.app")!,
      keyValueStorageService: .mock
    )
  }
}
