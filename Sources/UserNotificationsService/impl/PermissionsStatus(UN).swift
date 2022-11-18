//	Created by Leopold Lemmermann on 18.11.22.

import PushNotificationService
import UserNotifications

extension PermissionStatus {
  init(unStatus: UNAuthorizationStatus) {
    switch unStatus {
    case .authorized:
      self = .authorized
    case .notDetermined:
      self = .notDetermined
    case .denied, .ephemeral, .provisional:
      self = .notAuthorized
    @unknown default:
      self = .notAuthorized
    }
  }
}
