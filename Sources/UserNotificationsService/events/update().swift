//	Created by Leopold Lemmermann on 18.11.22.

import Concurrency
import Foundation

#if canImport(UIKit)
  import UIKit

  @available(iOS 15, *)
  extension UserNotificationsService {
    func updateAuthorizedOnDidBecomeActive(_ automaticRequest: Bool) async {
      for await _ in NotificationCenter.default.notifications(named: await UIApplication.didBecomeActiveNotification) {
        isAuthorized = automaticRequest ? await requestAuthorization() : await getAuthorizationStatus()
      }
    }
  }

#elseif canImport(AppKit)
  import AppKit

  @available(macOS 12, *)
  extension UserNotificationsService {
    func updateAuthorizedOnDidBecomeActive(_ automaticRequest: Bool) async {
      for await _ in NotificationCenter.default.notifications(named: await NSApplication.didBecomeActiveNotification) {
        isAuthorized = automaticRequest ? await requestAuthorization() : await getAuthorizationStatus()
      }
    }
  }
#endif
