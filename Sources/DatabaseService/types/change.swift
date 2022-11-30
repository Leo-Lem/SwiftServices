//  Created by Leopold Lemmermann on 08.11.22.

import class Combine.PassthroughSubject

/// The publisher providing change messages for local database changes.
public typealias DidChangePublisher = PassthroughSubject<DatabaseChange, Never>

/// The possible change messages of the service.
public enum DatabaseChange {
  /// The ``DatabaseStatus`` changed.
  case status(DatabaseStatus)
  /// A ``DatabaseObjectConvertible/DatabaseObject`` was inserted.
  case inserted(_ convertible: any DatabaseObjectConvertible)
  /// A ``DatabaseObjectConvertible/DatabaseObject`` of type with id was deleted.
  case deleted(_ type: any DatabaseObjectConvertible.Type, id: any CustomStringConvertible)
  /// Other changes, which cannot defined more exactly
  case remote
}
