//	Created by Leopold Lemmermann on 24.10.22.

import Queries

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension CloudKitService {
  func mapToDatabaseObject<T: Convertible>(_ convertible: T) async throws -> T.DatabaseObject {
    var databaseObject = try await fetchDatabaseObject(T.self, with: convertible.id) ?? create(T.self, with: convertible.id)
    convertible.mapProperties(onto: &databaseObject)
    return databaseObject
  }

  func create<T: Convertible>(_: T.Type, with id: T.ID) throws -> T.DatabaseObject {
    CKRecord(recordType: T.typeID, recordID: .init(recordName: id.description))
      .castToDatabaseObject(of: T.self)
  }
}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension CKRecord {
  static func castFrom(databaseObject: Any) -> Self {
    guard let record = databaseObject as? Self else {
      fatalError("Your database object (\(type(of: databaseObject))) is incompatible.")
    }

    return record
  }

  func castToDatabaseObject<T: CloudKitService.Convertible>(of: T.Type) -> T.DatabaseObject {
    guard let databaseObject = self as? T.DatabaseObject else {
      fatalError("Your database object (\(T.DatabaseObject.self)) is incompatible.")
    }

    return databaseObject
  }
}
