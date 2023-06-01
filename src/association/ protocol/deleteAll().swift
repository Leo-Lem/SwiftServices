//	Created by Leopold Lemmermann on 15.11.22.

public extension AssociationService {
  /// Delete all stored items.
  func deleteAll() { keys.forEach(delete) }
}
