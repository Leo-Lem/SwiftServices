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
    _ type: T.Type = T.self, with id: T.ID, modification: (inout T) -> Void
  ) async throws -> T {
    if var convertible: T = try await fetch(with: id) {
      modification(&convertible)
      try await insert(convertible)
      return convertible
    } else { throw DatabaseError.doesNotExist(T.self, id: id) }
  }
}
