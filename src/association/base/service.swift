//	Created by Leopold Lemmermann on 29.10.22.

import Foundation

public protocol KeyValueStorageService {
  associatedtype Key: LosslessStringConvertible
  
  func store<T>(_ item: T, for key: Key, securely: Bool)

  func load<T>(for key: Key, securely: Bool) -> T?

  func delete(for key: Key, securely: Bool)

  func allKeys() -> [Key]
}

public extension KeyValueStorageService {
  func store<T>(_ item: T, for key: Key, securely: Bool = false) { store(item, for: key, securely: securely) }
  func load<T>(for key: Key, securely: Bool = false) -> T? { load(for: key, securely: securely) }
  func delete(for key: Key, securely: Bool = false) { delete(for: key, securely: securely) }
}
