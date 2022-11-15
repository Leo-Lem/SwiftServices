//  Created by Leopold Lemmermann on 08.10.22.

import Queries
@testable import RemoteDatabaseService
import XCTest

class RemoteDatabaseServiceTests: XCTestCase {
  var service: RemoteDatabaseService!

  override func setUp() async throws {
    try XCTSkipIf(
      service == nil,
      "Subclass these tests and insert an implementation of the remote database service in the initializer!"
    )
  }

  func testPublishing() async throws {
    let convertible = Example1()

    var result = try await service.exists(with: convertible.id, type(of: convertible))
    XCTAssertFalse(result, "Remote model exists without publishing.")

    try await service.publish(convertible)

    result = try await service.exists(with: convertible.id, type(of: convertible))
    XCTAssertTrue(result, "Remote model does not exist after publishing.")
  }

  func testUnpublishing() async throws {
    let convertible = Example1()

    try await service.publish(convertible)

    var result = try await service.exists(with: convertible.id, type(of: convertible))
    XCTAssertTrue(result, "Remote model does not exist after publishing.")

    try await service.unpublish(with: convertible.id, type(of: convertible))

    result = try await service.exists(with: convertible.id, type(of: convertible))
    XCTAssertFalse(result, "Remote model still exists after unpublishing.")
  }

  func testFetching() async throws {
    let convertibles = createHeterogenousTestData(10)

    try await service.publish(convertibles)

    let result = try await service.fetchAndCollect(Query<Example1>(true))
    XCTAssertFalse(result.isEmpty, "No projects were fetched.")
  }
}
