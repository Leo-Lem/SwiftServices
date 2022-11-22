//	Created by Leopold Lemmermann on 29.10.22.

import Concurrency
import Foundation
import KeyValueStorageService

open class UserDefaultsService: KeyValueStorageService {
  let local: UserDefaults
  let cloud: NSUbiquitousKeyValueStore?

  public init(_ defaults: UserDefaults = .standard) {
    local = defaults
    cloud = nil
  }

  // cloud

  static let cloudPrefix = "cloud-"
  var ignoreChanges = false

  private let tasks = Tasks()

  @available(macOS 12, *)
  @available(iOS 15, *)
  public init(
    _ localDefaults: UserDefaults = .standard,
    cloudDefaults: NSUbiquitousKeyValueStore?
  ) {
    local = localDefaults
    cloud = cloudDefaults

    if cloud != nil {
      let center = NotificationCenter.default

      tasks.add(
        center
          .publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification)
          .getTask(.background, operation: updateLocal),
        center
          .publisher(for: UserDefaults.didChangeNotification)
          .getTask(.background, operation: updateRemote)
      )

      cloud?.synchronize()
    }
  }

  public func store<T, Key: CustomStringConvertible>(
    _ item: T,
    for key: Key,
    secure: Bool = false
  ) {
    if secure {
      storeSecure(item, for: key)
    } else {
      local.set(item, forKey: key.description)
    }
  }

  public func load<T, Key: CustomStringConvertible>(
    for key: Key,
    secure: Bool = false
  ) -> T? {
    if secure {
      return loadSecure(for: key)
    } else {
      return local.object(forKey: key.description) as? T
    }
  }

  public func delete<Key: CustomStringConvertible>(
    for key: Key,
    secure: Bool = false
  ) {
    if secure {
      return deleteSecure(for: key)
    } else {
      local.removeObject(forKey: key.description)
    }
  }

  public func allKeys() -> [String] {
    local
      .dictionaryRepresentation()
      .keys
      .compactMap { $0 as String }
  }
}
