//	Created by Leopold Lemmermann on 22.11.22.

import Concurrency
import Foundation

@available(iOS 15, macOS 12, *)
extension UserDefaultsService {
  @Sendable func handleLocalChange() async {
    for await _ in NotificationCenter.default.stream(for: UserDefaults.didChangeNotification) {
      guard let cloud = cloud else { return }
      
      for (key, value) in local.dictionaryRepresentation() {
        guard key.hasPrefix(Self.cloudPrefix) else { continue }
        cloud.set(value, forKey: key)
      }
    }
  }
}
