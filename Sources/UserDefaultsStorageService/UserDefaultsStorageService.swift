//	Created by Leopold Lemmermann on 29.10.22.

import Combine
import Concurrency
import Foundation
import KeyValueStorageService

open class UserDefaultsStorageService: KeyValueStorageService {
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

  public func store<T, Key: CustomStringConvertible>(_ item: T, for key: Key) {
    local.set(item, forKey: key.description)
  }

  public func load<T, Key: CustomStringConvertible>(for key: Key) -> T? {
    local.object(forKey: key.description) as? T
  }

  public func delete<Key: CustomStringConvertible>(for key: Key) {
    local.removeObject(forKey: key.description)
  }

  public func allKeys() -> [String] {
    local
      .dictionaryRepresentation()
      .keys
      .compactMap { $0 as String }
  }
}

private extension UserDefaultsStorageService {
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
