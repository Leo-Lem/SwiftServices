//	Created by Leopold Lemmermann on 09.11.22.

import CloudKit
@testable import CloudKitService
import RemoteDatabaseServiceTests
import XCTest

class CloudKitServiceTests: RemoteDatabaseServiceTests {
  override func setUp() async throws {
    service = await CloudKitService(MockCloudKitContainer())

    // verifies the service can be used before starting
    guard case .available = service.status else { throw XCTSkip("Missing write permissions.") }

    // cleans up any leftover data
    try await service.unpublishAll(Example1.self)
    try await service.unpublishAll(Example2.self)
  }
}
