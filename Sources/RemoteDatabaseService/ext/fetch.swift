//	Created by Leopold Lemmermann on 09.11.22.

import Queries

public extension RemoteDatabaseService {
  func fetch<T: RemoteModelConvertible>(_ convertible: T) async throws -> T? {
    try await fetch(with: convertible.id)
  }
  
  func fetch<T: RemoteModelConvertible>(with id: T.ID) async throws -> T? {
    try await fetchAndCollect(Query<T>("id", .equal, id.description)).first
  }

  func fetchAndCollect<T: RemoteModelConvertible>(_ query: Query<T>) async throws -> [T] {
    var values = [T]()
    for try await value in fetch(query) { values.append(value) }
    return values
  }
}
