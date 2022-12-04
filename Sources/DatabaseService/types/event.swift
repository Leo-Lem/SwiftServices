//  Created by Leopold Lemmermann on 08.11.22.

/// The possible service events.
public enum DatabaseEvent {
  /// The ``DatabaseStatus`` changed.
  case status(DatabaseStatus)
  /// A ``DatabaseObjectConvertible/DatabaseObject`` was inserted.
  case inserted(_ convertible: any DatabaseObjectConvertible)
  /// A ``DatabaseObjectConvertible/DatabaseObject`` of type with id was deleted.
  case deleted(_ type: any DatabaseObjectConvertible.Type, id: any CustomStringConvertible)
  /// Other changes, which cannot defined more exactly
  case remote
}
