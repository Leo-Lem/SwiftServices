//	Created by Leopold Lemmermann on 03.12.22.

import Concurrency
import Foundation

@available(iOS 15, macOS 12, *)
extension UserDefaultsService {
  @Sendable func handleRemoteChange() async {
    for await _ in NotificationCenter.default.stream(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification) {
      guard let cloud = cloud else { return }
      
      ignoreChanges = true
      defer { ignoreChanges = false }
      
      for (key, value) in cloud.dictionaryRepresentation {
        guard key.hasPrefix(Self.cloudPrefix) else { continue }
        local.set(value, forKey: key)
      }
    }
  }
}
