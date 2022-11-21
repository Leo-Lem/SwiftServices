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

    let newCredential = try await service.login(credential)
    XCTAssertEqual(newCredential, credential, "The credentials don't match.")
    XCTAssertEqual(service.status, .authenticated(credential), "User is not authenticated.")
  }

  func testChangingPIN() async throws {
    let credential = Credential.example
    let newPIN = "1234"
    
    try await service.login(credential)
    let newCredential = try await service.changePIN(newPIN)
    XCTAssertEqual(newCredential.pin, newPIN, "The new pin was not assigned.")
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
