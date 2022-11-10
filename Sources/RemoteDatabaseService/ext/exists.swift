//	Created by Leopold Lemmermann on 09.11.22.

public extension RemoteDatabaseService {
  func exists<T: RemoteModelConvertible>(with id: String, _: T.Type = T.self) async throws -> Bool {
    try await fetch(with: id) as T? != nil
  }
}
