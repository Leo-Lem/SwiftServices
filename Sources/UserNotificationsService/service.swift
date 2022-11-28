
import Combine
import Concurrency
import PushNotificationService
import UserNotifications

open class UserNotificationsService: PushNotificationService {
  public let didChange = PassthroughSubject<PushNotificationChange, Never>()

  public internal(set) var isAuthorized: Bool? {
    didSet {
      if let isAuthorized = isAuthorized {
        didChange.send(.authorization(isAuthorized: isAuthorized))
      }
    }
  }

  let tasks = Tasks()

  @available(iOS 15, macOS 12, *)
  public init(_ automaticPermissionRequest: Bool = false) async {
    isAuthorized = automaticPermissionRequest ? await authorize() : await getAuthorizationStatus()

    tasks.add(updateAuthorizedOnDidBecomeActive(automaticPermissionRequest))
  }

  @discardableResult
  public func authorize() async -> Bool? {
    if await getAuthorizationStatus() == nil {
      isAuthorized = await requestAuthorization()
    }

    return isAuthorized
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
