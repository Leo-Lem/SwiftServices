//	Created by Leopold Lemmermann on 09.11.22.

public extension RemoteDatabaseService {
  func unpublish<T: RemoteModelConvertible>(_ model: T) async throws {
    try await unpublish(with: model.id, T.self)
  }
  
  func unpublishAll<T: RemoteModelConvertible>(_: T.Type = T.self) async throws {
    try await unpublish(try await fetchAndCollect(Query<T>(true)))
  }
  
  @_disfavoredOverload
  func unpublish<T: RemoteModelConvertible>(_ convertibles: T...) async throws { try await unpublish(convertibles) }
  func unpublish<T: RemoteModelConvertible>(_ convertibles: [T]) async throws {
    for convertible in convertibles { try await unpublish(convertible) }
  }

  @_disfavoredOverload
  func unpublish(_ convertibles: any RemoteModelConvertible...) async throws { try await unpublish(convertibles) }
  func unpublish(_ convertibles: [any RemoteModelConvertible]) async throws {
    for convertible in convertibles { try await unpublish(convertible) }
  }
}
