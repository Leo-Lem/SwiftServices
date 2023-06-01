//	Created by Leopold Lemmermann on 03.12.22.

import class Foundation.NotificationCenter
import class Foundation.NSUbiquitousKeyValueStore

extension CloudDefaultsService {
  @Sendable internal func handleRemoteChange() async {
    for await _ in NotificationCenter.default.notifications(
      named: NSUbiquitousKeyValueStore.didChangeExternallyNotification
    ) {
      ignoreChanges = true
      defer { ignoreChanges = false }
      
      for (key, value) in _cloud.dictionaryRepresentation where key.hasPrefix(Self.cloudPrefix) {
        _defaults.set(value, forKey: key)
      }
    }
  }
}
