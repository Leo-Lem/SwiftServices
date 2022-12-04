import Concurrency

public protocol PushNotificationService: EventDriver where Event == NotificationEvent {
  var isAuthorized: Bool? { get }
  
  @discardableResult func authorize() async -> Bool?
  func schedule<T: PushNotification>(_ notification: T) async
  func cancel<T: PushNotification>(with id: T.ID, _: T.Type)
}
