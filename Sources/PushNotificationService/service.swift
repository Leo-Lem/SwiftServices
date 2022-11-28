
import Combine

public protocol PushNotificationService {
  var didChange: PassthroughSubject<PushNotificationChange, Never> { get }

  var isAuthorized: Bool? { get }
  
  @discardableResult func authorize() async -> Bool?
  func schedule<T: PushNotification>(_ notification: T) async
  func cancel<T: PushNotification>(with id: T.ID, _: T.Type)
}
