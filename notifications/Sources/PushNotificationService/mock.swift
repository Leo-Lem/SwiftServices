//	Created by Leopold Lemmermann on 20.10.22.

public extension PushNotificationService where Self == MockPushNotificationService {
  static var mock: Self { Self() }
}

open class MockPushNotificationService: PushNotificationService {
  public let eventPublisher = Publisher<NotificationEvent>()

  public var isAuthorized: Bool?

  public init() {}
  
  @discardableResult
  public func authorize() async -> Bool? {
    self.isAuthorized = true
    return true
  }

  public func schedule<T: PushNotification>(_ notification: T) {
    print(isAuthorized ?? false ? "Notification (\(notification)) scheduled!" : "Not authorized!")
  }

  public func cancel<T: PushNotification>(with id: T.ID, _: T.Type) {
    print("Notification (\(id)) canceled!")
  }
}
