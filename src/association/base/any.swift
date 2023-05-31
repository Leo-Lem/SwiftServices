//	Created by Leopold Lemmermann on 03.12.22.

public class AnyAssociationService<Key: LosslessStringConvertible>: AssociationService {
  public func store<T>(_ item: T, for key: Key) { _store(item, key) }
  public func load<T>(for key: Key) -> T? { _load(key).flatMap { $0 as! T? } }
  public func delete(for key: Key) { _delete(key) }
  public func allKeys() -> [Key] { _allKeys() }
  
  internal let _store: (Any, Key) -> Void
  internal let _load: (Key) -> Any?
  internal let _delete: (Key) -> Void
  internal let _allKeys: () -> [Key]
  
  public required init<S: AssociationService>(_ service: S) where S.Key == Key {
    _store = service.store
    _load = service.load
    _delete = service.delete
    _allKeys = service.allKeys
  }
}
