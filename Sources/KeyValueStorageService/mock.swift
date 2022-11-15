//	Created by Leopold Lemmermann on 15.11.22.

public class MockKeyValueStorageService: KeyValueStorageService {
  public init() {}
  
  public func store<T, Key: CustomStringConvertible>(_ item: T, for key: Key) {
    print("Stored \(item) for \(key).")
  }
  
  public func load<T, Key: CustomStringConvertible>(for key: Key) -> T?  {
    print("Loaded item for key.")
    return nil
  }
  
  public func delete<Key: CustomStringConvertible>(for key: Key) {
    print("Deleted item for \(key).")
  }
  
  public func allKeys() -> [String] {
    print("Returning all keys.")
    return []
  }
}
