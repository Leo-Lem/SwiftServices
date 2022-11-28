//	Created by Leopold Lemmermann on 18.11.22.

import PushNotificationService
import Concurrency
import Foundation

#if canImport(UIKit)
import UIKit

@available(iOS 15, macOS 12, *)
extension UserNotificationsService {
  func updateAuthorizedOnDidBecomeActive(_ automaticRequest: Bool) -> Task<Void, Never> {
    NotificationCenter.default
      .publisher(for: UIApplication.didBecomeActiveNotification)
      .getTask(.high) { [weak self] _ in
        if automaticRequest {
          await self?.authorize()
        } else {
          self?.isAuthorized = await self?.getAuthorizationStatus()
        }
      }
  }
}
#elseif canImport(AppKit)
import AppKit

@available(iOS 15, macOS 12, *)
extension UserNotificationsService {
  func updateAuthorizedOnDidBecomeActive(_ automaticRequest: Bool) -> Task<Void, Never> {
    NotificationCenter.default
      .publisher(for: NSApplication.didBecomeActiveNotification)
      .getTask(.high) { [weak self] _ in
        if automaticRequest {
          await self?.authorize()
        } else {
          self?.isAuthorized = await self?.getAuthorizationStatus()
        }
      }
  }
}
#endif
