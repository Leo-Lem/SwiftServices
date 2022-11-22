import AuthenticationService
import AuthenticationServiceTests
@testable import MyAuthenticationService
import KeyValueStorageService
import XCTest

class LLAuthenticationServiceTests: AuthenticationServiceTests {
  override func setUp() async throws {
    // TODO: mock the responses and remove the clear method
//    service = await MyAuthenticationService(
//      apiURL: "http://0.0.0.0:8080",
//      keyValueStorageService: MockKeyValueStorageService()
//    )
  }
}
