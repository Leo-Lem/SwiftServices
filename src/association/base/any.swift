//	Created by Leopold Lemmermann on 03.12.22.

import Foundation

public class AnyKeyValueStorageService<Key: LosslessStringConvertible>: KeyValueStorageService {
  public func store<T>(_ item: T, for key: Key, securely: Bool = false) { _store(item, key, securely) }
  public func load<T>(for key: Key, securely: Bool = false) -> T? { _load(key, securely).flatMap { $0 as! T? } }
  public func delete(for key: Key, securely: Bool = false) { _delete(key, securely) }
  public func allKeys() -> [Key] { _allKeys() }
  
  internal let _store: (Any, Key, Bool) -> Void
  internal let _load: (Key, Bool) -> Any?
  internal let _delete: (Key, Bool) -> Void
  internal let _allKeys: () -> [Key]
  
  public required init<S: KeyValueStorageService>(_ service: S) where S.Key == Key {
    _store = service.store
    _load = service.load
    _delete = service.delete
    _allKeys = service.allKeys
  }
}
