@testable import UserNotificationsService
import PushNotificationServiceTests

class UserNotificationsServiceTests: PushNotificationServiceTests {
  override func setUpWithError() throws {
    service = UserNotificationsService()
  }
}
