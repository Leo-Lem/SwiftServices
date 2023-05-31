//	Created by Leopold Lemmermann on 18.11.22.

public extension PushNotificationService {
  func cancel<T: PushNotification>(_ notification: T) {
    cancel(with: notification.id, T.self)
  }
}
