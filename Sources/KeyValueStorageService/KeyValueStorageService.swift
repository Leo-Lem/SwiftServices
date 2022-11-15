//	Created by Leopold Lemmermann on 29.10.22.

public protocol KeyValueStorageService {
  func store<T, Key: CustomStringConvertible>(_ item: T, for key: Key)
  
  func load<T, Key: CustomStringConvertible>(for key: Key) -> T?
  
  func delete<Key: CustomStringConvertible>(for key: Key)
  
  func allKeys() -> [String]
}
