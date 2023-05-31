//	Created by Leopold Lemmermann on 15.11.22.

import Foundation

public extension AnyKeyValueStorageService {
  static var mock: Self { Self(MockKeyValueStorageService()) }
}

public class MockKeyValueStorageService<Key: LosslessStringConvertible>: KeyValueStorageService {
  public init() {}

  var store = [String: Any]()
  var secureStore = [String: Any]()

  public func store<T>(_ item: T, for key: Key, securely: Bool = false) {
    securely ?
      (secureStore[key.description] = item) :
      (store[key.description] = item)

    print("Stored \(item) for \(key).")
  }

  public func load<T>(for key: Key, securely: Bool = false) -> T? {
    print("Loading item for \(key).")

    return securely ?
      secureStore[key.description] as? T :
      store[key.description] as? T
  }

  public func delete(for key: Key, securely: Bool = false) {
    _ = securely ?
      secureStore.removeValue(forKey: key.description) :
      store.removeValue(forKey: key.description)

    print("Deleted item for \(key)\(securely ? " from secure storage" : "").")
  }

  public func allKeys() -> [Key] {
    print("Returning all keys.")

    return store.keys.compactMap(Key.init)
  }
}
