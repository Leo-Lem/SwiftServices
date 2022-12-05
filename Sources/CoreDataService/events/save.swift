//	Created by Leopold Lemmermann on 08.11.22.

import Concurrency
import Errors

extension CoreDataService {
  func save(every interval: TimeInterval) async {
    for await _ in Timer.publish(every: interval, on: .main, in: .common).stream {
      if container.viewContext.hasChanges { printError(container.viewContext.save) }
    }
  }
  
  @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
  func saveOnResignActive() async {
    for await _ in await NotificationCenter.default.notifications(named: willResignActiveNotification) {
      if container.viewContext.hasChanges { printError(container.viewContext.save) }
    }
  }
}

#if canImport(UIKit)
  import UIKit

  extension CoreDataService {
    @MainActor var willResignActiveNotification: Notification.Name { UIApplication.willResignActiveNotification }
  }

#elseif canImport(AppKit)
  import AppKit

  extension CoreDataService {
    @MainActor var willResignActiveNotification: Notification.Name { NSApplication.willResignActiveNotification }
  }
#endif
