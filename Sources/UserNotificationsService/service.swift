
import PushNotificationService
import UserNotifications
import Concurrency
import Combine

open class UserNotificationsService: PushNotificationService {
  public let didChange = PassthroughSubject<PushNotificationChange, Never>()
  
  public internal(set) var isAuthorized: Bool?

  let tasks = Tasks()
  let center = UNUserNotificationCenter.current()

  @available(iOS 15, macOS 12, *)
  public init() async {
    await authorize()
    tasks.add(updateAuthorizedOnDidBecomeActive())
  }
  
  public func cancel<T: PushNotification>(with id: T.ID, _: T.Type) {
    center.removePendingNotificationRequests(withIdentifiers: [id.description])
  }
  
  public func schedule<T: PushNotification>(_ notification: T) {
    center.add(UNNotificationRequest(pushNotification: notification))
  }
}
