//	Created by Leopold Lemmermann on 18.11.22.

import PushNotificationService
import Concurrency
import Foundation

#if canImport(UIKit)
import UIKit

@available(iOS 15, macOS 12, *)
extension UserNotificationsService {
  func updateAuthorizedOnDidBecomeActive() -> Task<Void, Never> {
    NotificationCenter.default
      .publisher(for: UIApplication.didBecomeActiveNotification)
      .getTask(.high, operation: authorize)
  }
}
#elseif canImport(AppKit)
import AppKit

@available(iOS 15, macOS 12, *)
extension UserNotificationsService {
  func updateAuthorizedOnDidBecomeActive() -> Task<Void, Never> {
    NotificationCenter.default
      .publisher(for: NSApplication.didBecomeActiveNotification)
      .getTask(.high, operation: authorize)
  }
}
#endif
