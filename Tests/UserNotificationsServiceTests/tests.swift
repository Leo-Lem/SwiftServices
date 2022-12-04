@testable import UserNotificationsService
import BaseTests

@available(iOS 15, macOS 12, *)
class UserNotificationsServiceTests: PushNotificationServiceTests<UserNotificationsService> {
  override func setUp() async throws {
    throw XCTSkip("The service can't be used outside of an app it seems.")
    
    service = await .init()
  }
}
