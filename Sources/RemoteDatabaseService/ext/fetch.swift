//	Created by Leopold Lemmermann on 09.11.22.

import Queries

public extension RemoteDatabaseService {
  func fetch<T: RemoteModelConvertible>(_ convertible: T) async throws -> T? {
    try await fetch(with: convertible.id)
  }

  func fetchAndCollect<T: RemoteModelConvertible>(_ query: Query<T>) async throws -> [T] {
    var values = [T]()
    for try await value in fetch(query) { values.append(value) }
    return values
  }
}
