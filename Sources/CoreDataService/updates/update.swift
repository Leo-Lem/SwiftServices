//	Created by Leopold Lemmermann on 08.11.22.

import Concurrency

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension CoreDataService {
  func updateOnRemoteChange() -> Task<Void, Never> {
    NotificationCenter.default
      .publisher(for: .NSPersistentStoreRemoteChange)
      .getTask { [weak self] _ in self?.didChange.send(.remote) }
  }
}
