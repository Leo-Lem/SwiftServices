@_exported @testable import AuthenticationService
@_exported import XCTest

// !!!:  Subclass these tests and insert an implementation in the setUp method.
open class BaseTests<S: AuthenticationService>: XCTestCase {
  public var service: S!

  func testExists() async throws {
    let credential = Credential.example
    var exists = try await service.exists(credential.id)
    XCTAssertFalse(exists, "Credential exists without registering.")
    
    try await service.register(credential)
    exists = try await service.exists(credential.id)
    XCTAssertTrue(exists, "Credential doesn't exist after registering.")
  }
  
  func testRegistering() async throws {
    let credential = Credential.example

    let id = try await service.register(credential)
    XCTAssertEqual(id, credential.id, "The IDs don't match.")
    XCTAssertEqual(service.status, .authenticated(credential.id), "User is not logged in.")
  }
  
  func testLoggingIn() async throws {
    let credential = Credential.example

    try await service.register(credential)
    let id = try await service.login(credential)
    XCTAssertEqual(id, credential.id, "The IDs don't match.")
    XCTAssertEqual(service.status, .authenticated(credential.id), "User is not logged in.")
  }

  func testChangingPIN() async throws {
    do {
      var credential = Credential.example
      let newPIN = "1234"
      
      try await service.register(credential)
      try await service.changePIN(newPIN)
      try service.logout()
      
      credential.pin = newPIN
      let id = try await service.login(credential)
      XCTAssertEqual(id, credential.id, "The new pin is not accepted.")
      
      // resetting the pin
      try await service.changePIN(Credential.example.pin)
    } catch {
      print(error)
      throw error
    }
  }

  func testDeregistering() async throws {
    do {
      let credential = Credential.example
      
      try await service.register(credential)
      try await service.deregister()
      
      XCTAssertEqual(service.status, .notAuthenticated, "User is still logged in.")
    } catch {
      print(error)
      throw error
    }
  }

  func testLoggingOut() async throws {
    let credential = Credential.example

    try await service.register(credential)
    try service.logout()

    XCTAssertEqual(service.status, .notAuthenticated, "Logout was unsuccessful.")
  }
}
