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
    func saveOnResignActive() -> Task<Void, Never> {
      NotificationCenter.default
        .publisher(for: UIApplication.willResignActiveNotification)
        .getTask { [weak self] _ in printError { self?.save() } }
    }
  }

#elseif canImport(AppKit)
  import AppKit

  @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
  extension CoreDataService {
    func saveOnResignActive() -> Task<Void, Never> {
      NotificationCenter.default
        .publisher(for: NSApplication.willResignActiveNotification)
        .getTask { [weak self] _ in printError { self?.save() } }
    }
  }

#else
  @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
  extension CoreDataService {
    func saveOnResignActive() -> Task<Void, Never> {
      Task {}
    }
  }
#endif
