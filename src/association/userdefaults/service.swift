//	Created by Leopold Lemmermann on 30.10.22.

@_exported import AssociationService
import Concurrency
import Foundation

open class UserDefaultsService: AssociationService {
  internal let local: UserDefaults
  internal let cloud: NSUbiquitousKeyValueStore?

  internal static var cloudPrefix: String { "cloud-" }
  internal var ignoreChanges = false

  private let tasks = Tasks()

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

  public func store<T>(_ item: T, for key: any LosslessStringConvertible) {
    local.set(item, forKey: key.description)
  }

  public func load<T>(for key: any LosslessStringConvertible) -> T? {
    local.object(forKey: key.description) as? T
  }

  public func delete(for key: any LosslessStringConvertible) {
    local.removeObject(forKey: key.description)
  }

  public var keys: [String] {
    local.dictionaryRepresentation().keys.map { String($0) }
  }
}
