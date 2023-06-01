//	Created by Leopold Lemmermann on 03.12.22.

import class Foundation.NotificationCenter
import class Foundation.NSUbiquitousKeyValueStore

extension UserDefaultsService {
  @Sendable internal func handleRemoteChange() async {
    for await _ in NotificationCenter.default.notifications(
      named: NSUbiquitousKeyValueStore.didChangeExternallyNotification
    ) {
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
