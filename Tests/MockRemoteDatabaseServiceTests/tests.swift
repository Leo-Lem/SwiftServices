//	Created by Leopold Lemmermann on 23.11.22.

import BaseTests

@available(iOS 16, macOS 13, *)
final class MockRemoteDatabaseServiceTests: RemoteDatabaseServiceTests<Example1Impl, Example2Impl> {
  override func setUp() async throws {
    service = MockRemoteDatabaseService()
    
    try await service.unpublishAll(Example1Impl.self)
    try await service.unpublishAll(Example2Impl.self)
  }
}
