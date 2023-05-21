//	Created by Leopold Lemmermann on 18.11.22.

/// Events of the ``PushNotificationService``.
public enum NotificationEvent {
  /// A push notification was scheduled.
  case scheduled(any PushNotification)
  /// A push notification was cancelled
  case cancelled(any PushNotification)
  /// The authorization status changed.
  case authorization(isAuthorized: Bool)
}
