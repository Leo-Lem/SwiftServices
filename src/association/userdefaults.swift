//	Created by Leopold Lemmermann on 30.10.22.

import class Foundation.UserDefaults

/// A wrapper around `Foundation`'s UserDefaults implementing the ``AssociationService`` protocol.
open class UserDefaultsService: AssociationService {
  internal let _defaults: UserDefaults

  /// Initializes the service.
  /// - Parameter defaults: The `UserDefaults` to use for storage.
  public init(_ defaults: UserDefaults = .standard) { _defaults = defaults }

  public func store<T>(_ item: T, for key: any CustomStringConvertible) {
    _defaults.set(item, forKey: key.description)
  }

  public func load<T>(for key: any CustomStringConvertible) -> T? {
    _defaults.object(forKey: key.description) as? T
  }

  public func delete(for key: any CustomStringConvertible) {
    _defaults.removeObject(forKey: key.description)
  }

  public var keys: [String] {
    _defaults.dictionaryRepresentation().keys.map { String($0) }
  }
}
