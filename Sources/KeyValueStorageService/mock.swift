//	Created by Leopold Lemmermann on 15.11.22.

public class MockKeyValueStorageService: KeyValueStorageService {
  public init() {}

  public func store<T, Key: CustomStringConvertible>(
    _ item: T,
    for key: Key,
    secure: Bool = false
  ) {
    print("Stored \(item) for \(key)\(secure ? " securely." : ".").")
  }

  public func load<T, Key: CustomStringConvertible>(
    for key: Key,
    secure: Bool = false
  ) -> T? {
    print("Loaded item for \(key)\(secure ? " from secure storage." : ".").")
    return nil
  }

  public func delete<Key: CustomStringConvertible>(
    for key: Key,
    secure: Bool = false
  ) {
    print("Deleted item for \(key)\(secure ? " from secure storage." : ".")")
  }

  public func allKeys() -> [String] {
    print("Returning all keys.")
    return []
  }
}
