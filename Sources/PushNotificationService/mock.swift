//	Created by Leopold Lemmermann on 20.10.22.

import Combine

open class MockPushNotificationService: PushNotificationService {
  public let didChange = PassthroughSubject<PushNotificationChange, Never>()

  public var permissionStatus: PermissionStatus = .authorized

  public func schedule<T: PushNotification>(_ notification: T) {
    print(permissionStatus == .authorized ? "Notification (\(notification)) scheduled!" : "Not authorized!")
  }

  public func cancel<T: PushNotification>(with id: T.ID, _: T.Type) {
    print("Notification (\(id)) canceled!")
  }
}
