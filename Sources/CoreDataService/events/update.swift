//	Created by Leopold Lemmermann on 08.11.22.

import Concurrency

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension CoreDataService {
  func updateOnRemoteChange() async {
    for await _ in NotificationCenter.default.stream(for: .NSPersistentStoreRemoteChange) {
      eventPublisher.send(.remote)
    }
  }
}
