@testable import AuthenticationService
import XCTest

open class AuthenticationServiceTests: XCTestCase {
  public var service: AuthenticationService!

  override open func setUpWithError() throws {
    try XCTSkipIf(
      service == nil,
      "Subclass these AuthenticationServiceTests and assign an instance of LLAuthenticationService to 'service' in the setUpWithError!"
    )
  }

  func testLoggingIn() async throws {
    let credential = Credential.example

    let id = try await service.login(credential)
    XCTAssertEqual(id, credential.id, "The IDs don't match.")
    XCTAssertEqual(service.status, .authenticated(credential.id), "User is not authenticated.")
  }

  func testChangingPIN() async throws {
    var credential = Credential.example
    let newPIN = "1234"
    
    try await service.login(credential)
    try await service.changePIN(newPIN)
    try service.logout()
    
    credential.pin = newPIN
    let id = try await service.login(credential)
    XCTAssertEqual(id, credential.id, "The new pin is not accepted.")
  }
  
  func testDeregistering() async throws {
    let credential = Credential.example

    try await service.login(credential)
    try await service.deregister()
    
    XCTAssertEqual(service.status, .notAuthenticated, "User is still authenticated.")
  }

  func testLoggingOut() async throws {
    let credential = Credential.example

    try await service.login(credential)
    try service.logout()

    XCTAssertEqual(service.status, .notAuthenticated, "Logout was unsuccessful.")
  }
}
