//	Created by Leopold Lemmermann on 08.11.22.

import RemoteDatabaseService

extension RemoteDatabaseServiceTests {
  func fetch<T: RemoteModelConvertible>(_ convertible: T) async throws -> T? {
    try await service.fetch(with: convertible.id)
  }
}
