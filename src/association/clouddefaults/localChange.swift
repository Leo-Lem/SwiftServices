//	Created by Leopold Lemmermann on 22.11.22.

import class Foundation.NotificationCenter
import class Foundation.UserDefaults

extension CloudDefaultsService {
  @Sendable internal func handleLocalChange() async {
    for await _ in NotificationCenter.default.notifications(named: UserDefaults.didChangeNotification) {
      for (key, value) in _defaults.dictionaryRepresentation() where key.hasPrefix(Self.cloudPrefix) {
        _cloud.set(value, forKey: key)
      }
    }
  }
}
