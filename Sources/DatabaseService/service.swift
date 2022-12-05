//	Created by Leopold Lemmermann on 21.10.22.

@_exported import Queries
@_exported import Queries_KeyPath
import Concurrency

public protocol DatabaseService: Actor, EventDriver where Event == DatabaseEvent {
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
  /// - Throws: A ``DatabaseError``.
  func delete<T: DatabaseObjectConvertible>(_ type: T.Type, with id: T.ID) async throws
  
  /// Fetches a convertible from the database.
  /// - Parameter id: The ID of the ``DatabaseObjectConvertible`` to be fetched.
  /// - Returns: An instance of the ``DatabaseObjectConvertible`` and, if it cannot be found, nil.
  /// - Throws: A ``DatabaseError``.
  func fetch<T: DatabaseObjectConvertible>(with id: T.ID) async throws -> T?
  
  /// Fetches all convertibles matching the query from the database.
  /// - Parameter query: A `Queries/Query` for a ``DatabaseObjectConvertible`` type.
  /// - Returns: The results of the query provided as an `AsyncThrowingStream`.
  /// - Throws: A ``DatabaseError``.
  func fetch<T: DatabaseObjectConvertible>(_ query: Query<T>) -> AsyncThrowingStream<[T], Error>
}
