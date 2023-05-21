//	Created by Leopold Lemmermann on 23.11.22.

import BaseTests

final class MockDatabaseServiceTests: BaseTests<MockDatabaseService, Example1, Example2> {
  override func setUp() async throws {
    service = .mock
    
    try await service.deleteAll(Example1.self)
    try await service.deleteAll(Example2.self)
  }
}
