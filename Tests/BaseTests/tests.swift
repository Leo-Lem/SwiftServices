// !!!:  Subclass these tests and insert an implementation in the setUp method.
open class BaseTests<T>: XCTestCase {
  public var service: AuthenticationService!

  func testLoggingIn() async throws {
    let credential = Credential.example

    let id = try await service.login(credential)
    XCTAssertEqual(id, credential.id, "The IDs don't match.")
    XCTAssertEqual(service.status, .authenticated(credential.id), "User is not authenticated.")
  }

  func testChangingPIN() async throws {
    do {
      var credential = Credential.example
      let newPIN = "1234"
      
      try await service.login(credential)
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
      
      try await service.login(credential)
      try await service.deregister()
      
      XCTAssertEqual(service.status, .notAuthenticated, "User is still authenticated.")
    } catch {
      print(error)
      throw error
    }
  }

  func testLoggingOut() async throws {
    let credential = Credential.example

    try await service.login(credential)
    try service.logout()

    XCTAssertEqual(service.status, .notAuthenticated, "Logout was unsuccessful.")
  }
}
