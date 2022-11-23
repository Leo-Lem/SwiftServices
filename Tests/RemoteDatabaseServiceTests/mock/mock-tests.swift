//	Created by Leopold Lemmermann on 23.11.22.

import XCTest
import RemoteDatabaseService

@available(iOS 15, macOS 12, *)
class MockRemoteDatabaseServiceTests: RemoteDatabaseServiceTests<Example1Impl, Example2Impl> {
  override func setUp() async throws {
    service = MockRemoteDatabaseService()
    
    try await service.unpublishAll(Example1Impl.self)
    try await service.unpublishAll(Example2Impl.self)
  }
}

