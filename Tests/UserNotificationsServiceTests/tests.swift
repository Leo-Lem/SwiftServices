@testable import UserNotificationsService
import PushNotificationServiceTests

@available(iOS 15, macOS 12, *)
class UserNotificationsServiceTests: PushNotificationServiceTests {
  override func setUp() async throws {
    service = await UserNotificationsService()
  }
}
