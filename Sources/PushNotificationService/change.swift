//	Created by Leopold Lemmermann on 18.11.22.

public enum PushNotificationChange {
  case scheduled(any PushNotification),
       cancelled(any PushNotification),
       authorization(isAuthorized: Bool)
}
