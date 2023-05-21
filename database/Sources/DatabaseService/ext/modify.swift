//	Created by Leopold Lemmermann on 29.11.22.

public extension DatabaseService {
  /// Modifies the database object in the provided way
  /// - Parameters:
  ///   - type: The type of the ``DatabaseObjectConvertible``.
  ///   - id: The id of the ``DatabaseObjectConvertible``.
  ///   - modification: The modification to be applied.
  /// - Returns: A modified ``DatabaseObjectConvertible``.
  @discardableResult
  func modify<T: DatabaseObjectConvertible>(
    _ type: T.Type = T.self, with id: T.ID, modification: (inout T) async throws -> Void
  ) async throws -> T {
    if var convertible: T = try await fetch(with: id) {
      try await modification(&convertible)
      try await insert(convertible)
      return convertible
    } else { throw DatabaseError.doesNotExist(T.self, id: id) }
  }
  
  /// Modifies the database object in the provided way
  /// - Parameters:
  ///   - type: The type of the ``DatabaseObjectConvertible``.
  ///   - id: The id of the ``DatabaseObjectConvertible``.
  ///   - property: The key path of the modified property.
  ///   - newValue: The new value.
  /// - Returns: A modified ``DatabaseObjectConvertible``.
  @discardableResult
  func modify<T: DatabaseObjectConvertible, U>(
    _ type: T.Type = T.self, with id: T.ID, property: WritableKeyPath<T, U>, newValue: U
  ) async throws -> T {
    try await modify(with: id) { $0[keyPath: property] = newValue }
  }
}
