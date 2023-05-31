//	Created by Leopold Lemmermann on 29.10.22.

import Concurrency
import Foundation
@_exported import AssociationService

public extension AnyKeyValueStorageService {
  @available(iOS, obsoleted: 15)
  @available(macOS, obsoleted: 12)
  static func userDefaults(_ defaults: UserDefaults = .standard) -> Self {
    Self(UserDefaultsService(defaults))
  }
  
  @available(iOS 15, macOS 12, *)
  static func userDefaults(
    _ defaults: UserDefaults = .standard,
    cloudDefaults: NSUbiquitousKeyValueStore? = nil
  ) -> Self {
    Self(UserDefaultsService(defaults, cloudDefaults: cloudDefaults))
  }
}

open class UserDefaultsService<Key: LosslessStringConvertible>: KeyValueStorageService {
  internal let local: UserDefaults
  internal let cloud: NSUbiquitousKeyValueStore?

  internal static var cloudPrefix: String { "cloud-" }
  internal var ignoreChanges = false

  private let tasks = Tasks()

  @available(iOS, obsoleted: 15)
  @available(macOS, obsoleted: 12)
  public init(_ defaults: UserDefaults = .standard) {
    local = defaults
    cloud = nil
  }
  
  @available(iOS 15, macOS 12, *)
  public init(_ localDefaults: UserDefaults = .standard, cloudDefaults: NSUbiquitousKeyValueStore? = nil) {
    local = localDefaults
    cloud = cloudDefaults

    if cloud != nil {
      tasks.add(
        Task(priority: .background, operation: handleLocalChange),
        Task(priority: .background, operation: handleRemoteChange)
      )

      cloud?.synchronize()
    }
  }
  
  public func store<T>(_ item: T, for key: Key, securely: Bool = false) {
    securely ? storeSecurely(item, for: key) : store(item, for: key)
  }
  
  public func load<T>(for key: Key, securely: Bool = false) -> T? {
    securely ? loadSecurely(for: key) : load(for: key)
  }

  public func delete(for key: Key, securely: Bool = false) {
    securely ? deleteSecurely(for: key) : delete(for: key)
  }

  public func allKeys() -> [Key] {
    local.dictionaryRepresentation()
      .keys
      .compactMap(Key.init)
  }
}
