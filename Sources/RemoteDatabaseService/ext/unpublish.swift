//	Created by Leopold Lemmermann on 09.11.22.

import Queries

public extension RemoteDatabaseService {
  func unpublishAll<T: RemoteModelConvertible>(_: T.Type = T.self) async throws {
    try await unpublish(try await fetchAndCollect(Query<T>(true)))
  }
  
  func unpublish<T: RemoteModelConvertible>(_ model: T) async throws {
    try await unpublish(with: model.stringID, T.self)
  }
}
