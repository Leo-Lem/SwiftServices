//	Created by Leopold Lemmermann on 22.11.22.

import Foundation

extension UserDefaultsService {
  func updateLocal(_: Notification) {
    guard let cloud = cloud, !ignoreChanges else { return }

    for (key, value) in local.dictionaryRepresentation() {
      guard key.hasPrefix(Self.cloudPrefix) else { continue }
      cloud.set(value, forKey: key)
    }
  }

  func updateRemote(_: Notification) {
    guard let cloud = cloud else { return }

    ignoreChanges = true
    defer { ignoreChanges = false }

    for (key, value) in cloud.dictionaryRepresentation {
      guard key.hasPrefix(Self.cloudPrefix) else { continue }
      local.set(value, forKey: key)
    }
  }
}
