//	Created by Leopold Lemmermann on 09.11.22.

import Queries

public extension RemoteDatabaseService {
  func fetch<T: RemoteModelConvertible>(with id: String) async throws -> T? {
    try await fetchAndCollect(Query<T>("id", .equal, id)).first
  }

  func fetch<T: RemoteModelConvertible>(convertible: T) async throws -> T? {
    try await fetch(with: convertible.stringID)
  }

  func fetchAndCollect<T: RemoteModelConvertible>(_ query: Query<T>) async throws -> [T] {
    try await (fetch(query).collect())
  }
}
