//	Created by Leopold Lemmermann on 15.11.22.

public extension KeyValueStorageService {
  func deleteAll() { allKeys().forEach { delete(for: $0) } }
}
