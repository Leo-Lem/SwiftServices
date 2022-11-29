//	Created by Leopold Lemmermann on 09.11.22.

import Concurrency

public extension RemoteDatabaseService {
  func fetch<T: RemoteModelConvertible>(_ convertible: T) async throws -> T? {
    try await fetch(with: convertible.id)
  }
  
  func fetchAndCollect<T: RemoteModelConvertible>(_ query: Query<T>) async throws -> [T] {
    Array(try await fetch(query).collect().joined())
  }
  
  @_disfavoredOverload
  func fetch<T: RemoteModelConvertible>(with ids: T.ID...) -> AsyncThrowingStream<T, Error> { fetch(with: ids) }
  func fetch<T: RemoteModelConvertible>(with ids: [T.ID]) -> AsyncThrowingStream<T, Error> {
    ids.compactMap(fetch)
  }
}
