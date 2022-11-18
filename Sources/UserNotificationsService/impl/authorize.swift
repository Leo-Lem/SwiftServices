//	Created by Leopold Lemmermann on 18.11.22.

import PushNotificationService
import UserNotifications

extension UserNotificationsService {
  func authorize(_: Notification? = nil) async {
    var status = PermissionStatus(unStatus: await center.notificationSettings().authorizationStatus)

    if
      case .notDetermined = status,
      let success = try? await center.requestAuthorization(options: [.alert, .sound])
    {
      status = success ? .authorized : .notAuthorized
    }

    permissionStatus = status
  }
}
