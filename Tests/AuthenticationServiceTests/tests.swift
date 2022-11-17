@testable import AuthenticationService
import XCTest

open class AuthenticationServiceTests: XCTestCase {
  public var service: AuthenticationService!

  open override func setUpWithError() throws {
    try XCTSkipIf(
      service == nil,
      "Subclass these AuthenticationServiceTests and assign an instance of LLAuthenticationService to 'service' in the setUpWithError!"
    )
  }
}
