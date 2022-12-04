//	Created by Leopold Lemmermann on 18.11.22.

import class Combine.PassthroughSubject
import Concurrency

@available(iOS 15, macOS 12, *)
public extension PushNotificationService {
  var events: AsyncStream<PushNotificationEvent> { eventPublisher.stream }
}

public typealias PushNotificationEventPublisher = PassthroughSubject<PushNotificationEvent, Never>

/// Events of the ``PushNotificationService``.
public enum PushNotificationEvent {
  /// A push notification was scheduled.
  case scheduled(any PushNotification)
  /// A push notification was cancelled
  case cancelled(any PushNotification)
  /// The authorization status changed.
  case authorization(isAuthorized: Bool)
}
