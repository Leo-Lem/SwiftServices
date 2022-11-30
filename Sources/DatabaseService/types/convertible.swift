//	Created by Leopold Lemmermann on 21.10.22.

/// A type that's convertible to a database model.
///
/// Needs to be identifiable with a custom string convertible (for association).
public protocol DatabaseObjectConvertible: Identifiable where ID: CustomStringConvertible {
  /// The associated database object's type.
  associatedtype DatabaseObject

  /// A String identifier of the databae object's type
  static var typeID: String { get }

  /// Initializes the convertible from a ``DatabaseObject``
  /// - Parameter object: A ``DatabaseObject`` instance.
  init(from databaseObject: DatabaseObject)

  /// Maps the convetible's properties onto a ``DatabaseObject`` instance.
  /// - Parameter object: A inout ``DatabaseObject`` instance.
  func mapProperties(onto databaseObject: inout DatabaseObject)
}
