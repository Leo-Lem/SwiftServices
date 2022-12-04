//	Created by Leopold Lemmermann on 08.11.22.

import Concurrency
import Errors

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension CoreDataService {
  func save() {
    if container.viewContext.hasChanges { printError(container.viewContext.save) }
  }
}

#if canImport(UIKit)
  import UIKit

  @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
  extension CoreDataService {
    var saveOnResignActive: Task<Void, Never> {
      Task {
        for await _ in NotificationCenter.default.stream(for: await UIApplication.willResignActiveNotification) {
          save()
        }
      }
    }
  }

#elseif canImport(AppKit)
  import AppKit

  @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
  extension CoreDataService {
    var saveOnResignActive: Task<Void, Never> {
      Task {
        for await _ in NotificationCenter.default.stream(for: await NSApplication.willResignActiveNotification) {
          save()
        }
      }
    }
  }

#else
  @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
  extension CoreDataService {
    var saveOnResignActive = Task {}
  }
#endif
