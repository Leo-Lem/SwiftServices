//	Created by Leopold Lemmermann on 24.10.22.

import CloudKit
import Queries
import Queries_NSPredicate
import RemoteDatabaseService

extension CloudKitService {
  func mapToRemoteModel<T: RemoteModelConvertible>(_ convertible: T) async throws -> T.RemoteModel {
    convertible.mapProperties(
      onto: try await fetch(with: convertible.id, T.self) ?? (try create(convertible))
    )
  }

  func create<T: RemoteModelConvertible>(_ convertible: T) throws -> T.RemoteModel {
    try verifyIsRemoteModel(
      CKRecord(
        recordType: T.typeID,
        recordID: .init(recordName: convertible.id.description)
      ),
      T.self
    )
  }

  func getCKQuery<T: RemoteModelConvertible>(from query: Query<T>) -> CKQuery {
    CKQuery(recordType: T.typeID, predicate: query.getNSPredicate())
  }
}
