//	Created by Leopold Lemmermann on 31.10.22.

/// The error thrown by the ``DatabaseService``'s methods.
public enum DatabaseError: Error {
  /// The ``DatabaseObjectConvertible/DatabaseObject`` of type with id does not exist.
  case doesNotExist(_ type: any DatabaseObjectConvertible.Type, id: any CustomStringConvertible)
  /// Missing write permission for the database.
  case databaseIsReadOnly
  /// Database is unreachable.
  case databaseIsUnavailable
  /// Some other issue.
  case other(Error)
}
