//	Created by Leopold Lemmermann on 30.10.22.

import class Foundation.NSUbiquitousKeyValueStore
import class Foundation.UserDefaults

/// Adds iCloud synchronization to the ``UserDefaultsService``.
///
/// _Note_: Properties that should be synced hace to be prefixed with the ``cloudPrefix``.
open class CloudDefaultsService: UserDefaultsService {
  /// Default value: `cloud-`
  public static let cloudPrefix = "cloud-"

  internal let _cloud: NSUbiquitousKeyValueStore

  internal var ignoreChanges = false

  /// Initializes the service.
  /// - Parameters:
  ///   - cloud: The `NSUbiquitousKeyValueStore` to use.
  ///   - defaults: The `UserDefaults` to use for storage.
  public init(_ cloud: NSUbiquitousKeyValueStore = .default, defaults: UserDefaults = .standard) {
    self._cloud = cloud

    super.init(defaults)

    Task(priority: .background, operation: handleLocalChange)
    Task(priority: .background, operation: handleRemoteChange)

    _cloud.synchronize()
  }
}
