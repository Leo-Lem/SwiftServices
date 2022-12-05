//	Created by Leopold Lemmermann on 08.11.22.

import Concurrency
import Errors

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension CoreDataService {
  func savePeriodically() async {
    for await _ in Timer.publish(every: 30, on: .main, in: .common).stream { save() }
  }
  
  func saveOnResignActive() async {
    for await _ in NotificationCenter.default.stream(for: willResignActiveNotification) { save() }
  }
  
  private func save() {
    if container.viewContext.hasChanges { printError(container.viewContext.save) }
  }
}

#if canImport(UIKit)
  import UIKit

  @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
  extension CoreDataService {
    var willResignActiveNotification: Notification.Name { UIApplication.willResignActiveNotification }
  }

#elseif canImport(AppKit)
  import AppKit

  @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
  extension CoreDataService {
    var willResignActiveNotification: Notification.Name { NSApplication.willResignActiveNotification }
  }
#endif
