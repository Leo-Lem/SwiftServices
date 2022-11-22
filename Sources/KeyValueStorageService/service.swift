//	Created by Leopold Lemmermann on 29.10.22.

public protocol KeyValueStorageService {
  func store<T, Key: CustomStringConvertible>(
    _ item: T,
    for key: Key,
    secure: Bool
  )

  func load<T, Key: CustomStringConvertible>(
    for key: Key,
    secure: Bool
  ) -> T?

  func delete<Key: CustomStringConvertible>(
    for key: Key,
    secure: Bool
  )

  func allKeys() -> [String]
}

public extension KeyValueStorageService {
  func store<T, Key: CustomStringConvertible>(
    _ item: T,
    for key: Key,
    secure: Bool = false
  ) {
    store(item, for: key, secure: secure)
  }

  func load<T, Key: CustomStringConvertible>(
    for key: Key,
    secure: Bool = false
  ) -> T? {
    load(for: key, secure: secure)
  }

  func delete<Key: CustomStringConvertible>(
    for key: Key,
    secure: Bool = false
  ) {
    delete(for: key, secure: secure)
  }
}
