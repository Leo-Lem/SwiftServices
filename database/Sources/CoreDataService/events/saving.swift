//	Created by Leopold Lemmermann on 08.11.22.

import Concurrency
import Errors

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension CoreDataService {
  func save(every interval: TimeInterval) async {
    for await _ in Timer.publish(every: interval, on: .main, in: .common).stream { await save() }
  }

  func saveOnResignActive() async {
    for await _ in await NotificationCenter.default.notifications(named: willResignActiveNotification) { await save() }
  }
}

#if canImport(UIKit)
import UIKit

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension CoreDataService {
  @MainActor var willResignActiveNotification: Notification.Name { UIApplication.willResignActiveNotification }
}

#elseif canImport(AppKit)
import AppKit

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension CoreDataService {
  @MainActor var willResignActiveNotification: Notification.Name { NSApplication.willResignActiveNotification }
}
#endif
