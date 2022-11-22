//	Created by Leopold Lemmermann on 18.11.22.

import PushNotificationService
import UserNotifications

extension UserNotificationsService {
  func authorize(_: Notification? = nil) async {
    switch await center.notificationSettings().authorizationStatus {
    case .authorized, .ephemeral, .provisional:
      isAuthorized = true
    case .notDetermined:
      isAuthorized = (try? await center.requestAuthorization(options: [.alert, .sound])) ?? false
    case .denied:
      isAuthorized = false
    @unknown default:
      isAuthorized = nil
    }
  }
}
