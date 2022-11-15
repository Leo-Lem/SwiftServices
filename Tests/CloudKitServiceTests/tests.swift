//	Created by Leopold Lemmermann on 09.11.22.

import CloudKit
import CloudKitService
import XCTest

final class CloudKitServiceTests: RemoteDatabaseServiceTests {
  override func setUp() async throws {
    service = await CloudKitService(MockCKContainer())

    // verifies the service can be used before starting
    guard case .available = service.status else { throw XCTSkip("Missing write permissions.") }

    // cleans up any leftover data
    await deleteAll()
  }
}
