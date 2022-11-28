//	Created by Leopold Lemmermann on 28.11.22.

import UserNotifications

extension UserNotificationsService {
  @discardableResult
  func requestAuthorization() async -> Bool {
    do {
      return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
    } catch {
      print(error)
      return false
    }
  }

  @discardableResult
  func getAuthorizationStatus() async -> Bool? {
    switch await UNUserNotificationCenter.current().notificationSettings().authorizationStatus {
    case .authorized, .ephemeral, .provisional: return true
    case .notDetermined: return nil
    case .denied: return false
    @unknown default: return nil
    }
  }
}
