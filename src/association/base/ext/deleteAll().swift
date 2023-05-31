//	Created by Leopold Lemmermann on 15.11.22.

public extension AssociationService {
  func deleteAll() { allKeys().forEach { delete(for: $0) } }
}
