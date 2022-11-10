//	Created by Leopold Lemmermann on 09.11.22.

import CloudKit
import RemoteDatabaseService

public extension CloudKitService {
  func exists<T: RemoteModelConvertible>(with id: T.ID, _: T.Type = T.self) async throws -> Bool {
    try await mapToCloudKitError {
      do {
        try await database.record(for: CKRecord.ID(recordName: id.description))
        return true
      } catch let error as CKError where error.code == .unknownItem {
        return false
      }
    }
  }
}
