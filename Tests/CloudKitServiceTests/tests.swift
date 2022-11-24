//	Created by Leopold Lemmermann on 09.11.22.

import CloudKit
@testable import CloudKitService
import RemoteDatabaseServiceTests
import XCTest

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
class CloudKitServiceTests: RemoteDatabaseServiceTests<Example1Impl, Example2Impl> {
  override func setUp() async throws {
    service = await CloudKitService(MockCloudKitContainer())

    // verifies the service can be used before starting
    guard case .available = service.status else { throw XCTSkip("Missing write permissions.") }

    // cleans up any leftover data
    try await service.unpublishAll(Example1Impl.self)
    try await service.unpublishAll(Example2Impl.self)
  }
}
