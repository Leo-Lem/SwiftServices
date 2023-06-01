//	Created by Leopold Lemmermann on 24.10.22.

import Queries

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
