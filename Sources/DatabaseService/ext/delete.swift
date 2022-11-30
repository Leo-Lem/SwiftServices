//	Created by Leopold Lemmermann on 09.11.22.

public extension DatabaseService {
  /// Deletes the convertible from the database.
  /// - Parameter convertible: The ``DatabaseObjectConvertible`` to delete.
  ///  - Throws: A ``DatabaseError``.
  func delete<T: DatabaseObjectConvertible>(_ convertible: T) async throws {
    try await delete(T.self, with: convertible.id)
  }

  /// Deletes all database objects of the given type from the database.
  /// - Parameter type: The ``DatabaseObjectConvertible`` type.
  ///  - Throws: A ``DatabaseError``.
  func deleteAll<T: DatabaseObjectConvertible>(_: T.Type) async throws {
    try await delete(try await fetchAndCollect(Query<T>(true)))
  }

  /// Batch delete convertibles from the database.
  /// - Parameter convertibles: The ``DatabaseObjectConvertible``s to be deleted.
  ///  - Throws: A ``DatabaseError``.
  func delete<T: DatabaseObjectConvertible>(_ convertibles: [T]) async throws {
    for convertible in convertibles { try await delete(convertible) }
  }

  /// Heterogenous batch delete convertibles from the database.
  /// - Parameter convertibles: The ``DatabaseObjectConvertible``s to be deleted.
  ///  - Throws: A ``DatabaseError``.
  func delete(_ convertibles: [any DatabaseObjectConvertible]) async throws {
    for convertible in convertibles { try await delete(convertible) }
  }
}
