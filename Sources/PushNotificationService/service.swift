
import Combine

public protocol PushNotificationService {
  var didChange: PassthroughSubject<PushNotificationChange, Never> { get }

  var permissionStatus: PermissionStatus { get }

  func schedule<T: PushNotification>(_ notification: T)
  func cancel<T: PushNotification>(with id: T.ID, _: T.Type)
}
