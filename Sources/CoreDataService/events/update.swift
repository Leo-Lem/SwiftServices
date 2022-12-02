//	Created by Leopold Lemmermann on 08.11.22.

import Concurrency

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension CoreDataService {
  var updateOnRemoteChange: Task<Void, Never> {
    Task {
      for await _ in NotificationCenter.default.stream(for: .NSPersistentStoreRemoteChange) {
        eventPublisher.send(.remote)
      }
    }
  }
}
