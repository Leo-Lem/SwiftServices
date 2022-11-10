//	Created by Leopold Lemmermann on 08.11.22.

import RemoteDatabaseService

extension RemoteDatabaseServiceTests {
  func fetch<T: RemoteModelConvertible>(_ convertible: T) async throws -> T? {
    try await service.fetch(with: convertible.id)
  }

  func deleteAll() async {
    do {
      try await service.unpublishAll(Example1.self)
      try await service.unpublishAll(Example2.self)
    } catch { debugPrint(error.localizedDescription) }
  }
}
