//	Created by Leopold Lemmermann on 22.11.22.

import class Foundation.NotificationCenter
import class Foundation.UserDefaults

extension UserDefaultsService {
  @Sendable internal func handleLocalChange() async {
    for await _ in NotificationCenter.default.notifications(named: UserDefaults.didChangeNotification) {
      guard let cloud = cloud else { return }
      
      for (key, value) in local.dictionaryRepresentation() {
        guard key.hasPrefix(Self.cloudPrefix) else { continue }
        cloud.set(value, forKey: key)
      }
    }
  }
}
