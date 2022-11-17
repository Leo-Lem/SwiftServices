//  Created by Leopold Lemmermann on 08.10.22.

import Queries
@testable import RemoteDatabaseService
import XCTest

open class RemoteDatabaseServiceTests: XCTestCase {
  public var service: RemoteDatabaseService!

  override open func setUpWithError() throws {
    try XCTSkipIf(
      service == nil,
      "Subclass these RemoteDatabaseServiceTests and assign an instance of CloudKitService to 'service' in the setUpWithError!"
    )
  }

  // FIXME: tests cannot run because of the conformance to RemoteModelConvertible
//  func testPublishing() async throws {
//    assert(Example1.self is any RemoteModelConvertible , "You need to conform Example1 to RemoteModelConvertible!")
//
//    var result = try await service.exists(with: convertible.id, type(of: convertible))
//    XCTAssertFalse(result, "Remote model exists without publishing.")
//
//    try await service.publish(convertible)
//
//    result = try await service.exists(with: convertible.id, type(of: convertible))
//    XCTAssertTrue(result, "Remote model does not exist after publishing.")
//  }

//  func testUnpublishing() async throws {
//    let convertible = Example1()
//
//    try await service.publish(convertible)
//
//    var result = try await service.exists(with: convertible.id, type(of: convertible))
//    XCTAssertTrue(result, "Remote model does not exist after publishing.")
//
//    try await service.unpublish(with: convertible.id, type(of: convertible))
//
//    result = try await service.exists(with: convertible.id, type(of: convertible))
//    XCTAssertFalse(result, "Remote model still exists after unpublishing.")
//  }

//  func testFetching() async throws {
//    let convertibles = createHeterogenousTestData(10)
//
//    try await service.publish(convertibles)
//
//    let result = try await service.fetchAndCollect(Query<Example1>(true))
//    XCTAssertFalse(result.isEmpty, "No projects were fetched.")
//  }
}
