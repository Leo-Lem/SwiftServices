//	Created by Leopold Lemmermann on 21.10.22.

import Concurrency
import Foundation
@_exported import Queries
@_exported import Queries_KeyPath

public protocol DatabaseService: ObservableObject, EventDriver where Event == DatabaseEvent {
  /// The database's current status.
  var status: DatabaseStatus { get }

  /// Inserts a convertible into the database.
  /// - Parameter convertible: Some ``DatabaseObjectConvertible``.
  /// - Returns: The provided ``DatabaseObjectConvertible``.
  /// - Throws: A ``DatabaseError``.
  @discardableResult
  func insert<T: DatabaseObjectConvertible>(_ convertible: T) async throws -> T

  /// Deletes a convertible from the database.
  /// - Parameters:
  ///  - type:  The type of the ``DatabaseObjectConvertible`` to be deleted.
  ///  - id: The ID of the ``DatabaseObjectConvertible`` to be deleted.
  /// - Returns: `nil`.
  /// - Throws: A ``DatabaseError``.
  @discardableResult
  func delete<T: DatabaseObjectConvertible>(_ type: T.Type, with id: T.ID) async throws -> T?

  /// Fetches a convertible from the database.
  /// - Parameters:
  ///   - type:  The type of the ``DatabaseObjectConvertible`` to be fetched.
  ///   - id: The ID of the ``DatabaseObjectConvertible`` to be fetched.
  /// - Returns: An instance of the ``DatabaseObjectConvertible`` and, if it cannot be found, nil.
  /// - Throws: A ``DatabaseError``.
  func fetch<T: DatabaseObjectConvertible>(_ type: T.Type, with id: T.ID) async throws -> T?

  /// Fetches all convertibles matching the query from the database.
  /// - Parameter query: A `Queries/Query` for a ``DatabaseObjectConvertible`` type.
  /// - Returns: The results of the query provided as an `AsyncThrowingStream`.
  /// - Throws: A ``DatabaseError``.
  func fetch<T: DatabaseObjectConvertible>(_ query: Query<T>) async throws -> AsyncThrowingStream<[T], Error>
}

public extension DatabaseService {
  @discardableResult
  func delete<T: DatabaseObjectConvertible>(_ type: T.Type = T.self, with id: T.ID) async throws -> T? {
    try await delete(type, with: id)
  }
  
  func fetch<T: DatabaseObjectConvertible>(_ type: T.Type = T.self, with id: T.ID) async throws -> T? {
    try await fetch(type, with: id)
  }
}
