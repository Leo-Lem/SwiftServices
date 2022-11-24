
import PushNotificationService
import UserNotifications
import Concurrency
import Combine

open class UserNotificationsService: PushNotificationService {
  public let didChange = PassthroughSubject<PushNotificationChange, Never>()
  
  public internal(set) var isAuthorized: Bool?
  
  let tasks = Tasks()

  @available(iOS 15, macOS 12, *)
  public init() async {
    await authorize()
    tasks.add(updateAuthorizedOnDidBecomeActive())
  }
  
  public func schedule<T: PushNotification>(_ notification: T) async {
    do {
      let center = UNUserNotificationCenter.current()
      try await center.add(UNNotificationRequest(pushNotification: notification))
    } catch { print(error) }
  }
  
  public func cancel<T: PushNotification>(with id: T.ID, _: T.Type) {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [id.description])
  }
}
