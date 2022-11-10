//	Created by Leopold Lemmermann on 09.11.22.

import CloudKit
import RemoteDatabaseService

public extension CloudKitService {
  func fetch<T: RemoteModelConvertible>(with id: T.ID) async throws -> T? {
    try await mapToCloudKitError {
      do {
        return try await fetch(with: id, T.self)
          .flatMap(T.init)
      } catch let error as CKError where error.code == .unknownItem {
        return nil
      }
    }
  }
}
