//	Created by Leopold Lemmermann on 29.10.22.

public protocol AssociationService {
  /// Store an item.
  /// - Parameters:
  ///   - item: The item to be stored.
  ///   - key: A `CustomStringConvertible` to associate the stored item with.
  func store<T>(_ item: T, for key: any CustomStringConvertible)

  /// Load a stored item.
  /// - Parameter key: A `CustomStringConvertible` associated with the loaded item.
  /// - Returns: The item to be loaded.
  func load<T>(for key: any CustomStringConvertible) -> T?

  /// Delete a stored item.
  /// - Parameter key: A `CustomStringConvertible`associated with the deleted item.
  func delete(for key: any CustomStringConvertible)

  /// The keys of all currently stored items.
  var keys: [String] { get }
}
