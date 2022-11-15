//	Created by Leopold Lemmermann on 29.10.22.

public protocol KeyValueStorageService {
  func insert<T>(_ item: T, for key: String) throws
  
  func load<T>(for key: String) throws -> T?
  
  func delete(for key: String) throws
}
