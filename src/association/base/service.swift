//	Created by Leopold Lemmermann on 29.10.22.

public protocol AssociationService {
  associatedtype Key: LosslessStringConvertible
  
  func store<T>(_ item: T, for key: Key)

  func load<T>(for key: Key) -> T?

  func delete(for key: Key)

  func allKeys() -> [Key]
}
