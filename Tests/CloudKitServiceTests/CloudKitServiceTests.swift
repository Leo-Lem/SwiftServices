//	Created by Leopold Lemmermann on 09.11.22.

import CloudKit
import CloudKitService
import RemoteDatabaseService
import XCTest

final class CloudKitServiceTests: RemoteDatabaseServiceTests {
  override func setUp() async throws {
    // !!!: these tests do not work, becausse cloudkit entitlements cannot be added to the package
    service = MockRemoteDatabaseService()
    
    // verifies the service can be used before starting
    guard case .available = service.status else { throw XCTSkip("Missing write permissions.") }

    // cleans up any leftover data
    await deleteAll()

    // leaving a little time for serverside actions
    if #available(iOS 16, macOS 13, *) {
      await sleep(for: .seconds(1))
    } else {
      try? await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
    }
  }
}
