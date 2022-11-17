@testable import PushNotificationService
import XCTest

open class PushNotificationServiceTests: XCTestCase {
  public var service: PushNotificationService!

  open override func setUpWithError() throws {
    try XCTSkipIf(
      service == nil,
      "Subclass these PushNotificationServiceTests and assign an instance of UserNotificationsService to 'service' in the setUpWithError!"
    )
  }
}
