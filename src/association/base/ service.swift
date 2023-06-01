//	Created by Leopold Lemmermann on 29.10.22.

public protocol AssociationService {
  func store<T>(_ item: T, for key: any LosslessStringConvertible)

  func load<T>(for key: any LosslessStringConvertible) -> T?

  func delete(for key: any LosslessStringConvertible)

  var keys: [String] { get }
}
