//	Created by Leopold Lemmermann on 09.11.22.

import Queries
import RemoteDatabaseService

public extension CloudKitService {
  @available(macOS 12, *)
  func unpublishAll<T: RemoteModelConvertible>(_: T.Type = T.self) async throws {
    let query = getCKQuery(from: Query<T>(true))
    let ids = try await container.publicCloudDatabase.records(matching: query).matchResults.map(\.0)
    _ = try await container.publicCloudDatabase.modifyRecords(saving: [], deleting: ids)

    didChange.send(.remote)
  }
}
