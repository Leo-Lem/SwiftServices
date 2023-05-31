//	Created by Leopold Lemmermann on 09.11.22.

public extension DatabaseService {
  /// Checks for the convertible's existence.
  /// - Parameter convertible: The ``DatabaseObjectConvertible`` for which to check.
  /// - Returns: A `Bool` indicating the existence.
  /// - Throws: A ``DatabaseError``.
  func exists<T: DatabaseObjectConvertible>(_ convertible: T) async throws -> Bool {
    try await exists(T.self, with: convertible.id)
  }
  
  /// Checks for the convertible's existence.
  /// - Parameters:
  ///  - type: The type of ``DatabaseObjectConvertible`` for which to check.
  ///  - id: The id of the ``DatabaseObjectConvertible`` for which to check.
  /// - Returns: A `Bool` indicating the existence.
  /// - Throws: A ``DatabaseError``.
  func exists<T: DatabaseObjectConvertible>(_: T.Type, with id: T.ID) async throws -> Bool {
    try await fetch(with: id) as T? != nil
  }
}
