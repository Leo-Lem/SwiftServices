//	Created by Leopold Lemmermann on 15.11.22.

public class MockKeyValueStorageService: KeyValueStorageService {
  public init() {}

  var store = [String: Any]()
  var secureStore = [String: Any]()

  public func store<T, Key: CustomStringConvertible>(
    _ item: T,
    for key: Key,
    secure: Bool = false
  ) {
    secure ?
      (store[key.description] = item) :
      (secureStore[key.description] = item)
    print("Stored \(item) for \(key)\(secure ? " securely." : ".").")
  }

  public func load<T, Key: CustomStringConvertible>(
    for key: Key,
    secure: Bool = false
  ) -> T? {
    print("Loaded item for \(key)\(secure ? " from secure storage." : ".").")

    return (
      secure ?
        store[key.description] :
        secureStore[key.description]
    ) as? T
  }

  public func delete<Key: CustomStringConvertible>(
    for key: Key,
    secure: Bool = false
  ) {
    _ = secure ?
      store.removeValue(forKey: key.description) :
      secureStore.removeValue(forKey: key.description)

    print("Deleted item for \(key)\(secure ? " from secure storage." : ".")")
  }

  public func allKeys() -> [String] {
    print("Returning all keys.")

    return Array(store.keys)
  }
}
