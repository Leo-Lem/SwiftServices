//	Created by Leopold Lemmermann on 09.11.22.

import Queries
import Concurrency

public extension RemoteDatabaseService {
  func fetch<T: RemoteModelConvertible>(_ convertible: T) async throws -> T? {
    try await fetch(with: convertible.id)
  }

  func fetchAndCollect<T: RemoteModelConvertible>(_ query: Query<T>) async throws -> [T] {
    Array(try await fetch(query).collect().joined())
  }
}
