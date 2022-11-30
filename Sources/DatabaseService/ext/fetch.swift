//	Created by Leopold Lemmermann on 09.11.22.

import Concurrency

public extension DatabaseService {
  /// Fetches a convertible from the database.
  /// - Parameter convertible: The ``DatabaseObjectConvertible`` to be fetched.
  /// - Returns: An instance of the ``DatabaseObjectConvertible`` and, if it cannot be found, nil.
  /// - Throws: A ``DatabaseError``.
  func fetch<T: DatabaseObjectConvertible>(_ convertible: T) async throws -> T? {
    try await fetch(with: convertible.id)
  }
  
  /// Fetches the query and waits for all results before returning.
  /// - Parameter query: A `Queries/Query` for a ``DatabaseObjectConvertible`` type.
  /// - Returns: An `Array` of ``DatabaseObjectConvertible``s.
  /// - Throws: A ``DatabaseError``.
  func fetchAndCollect<T: DatabaseObjectConvertible>(_ query: Query<T>) async throws -> [T] {
    Array(try await fetch(query).collect().joined())
  }
  
  /// Fetches convertibles for the provided ids.
  /// - Parameter ids: The ids for which to fetch the convertibles.
  /// - Returns: The results provided as an `AsyncThrowingStream`.
  /// - Throws: A ``DatabaseError``.
  func fetch<T: DatabaseObjectConvertible>(with ids: [T.ID]) -> AsyncThrowingStream<T, Error> {
    ids.compactMap(fetch)
  }
}
