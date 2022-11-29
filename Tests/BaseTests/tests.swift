//  Created by Leopold Lemmermann on 08.10.22.

// !!!:  Subclass these tests and insert an implementation to 'service' in the setUp method. (Like the mock tests)
open class RemoteDatabaseServiceTests<T1: Example1, T2: Example2>: XCTestCase {
  public var service: RemoteDatabaseService!

  func testPublishing() async throws {
    let convertible = T1.example
    var result = try await service.exists(with: convertible.id, T1.self)
    XCTAssertFalse(result, "Remote model exists without publishing.")

    try await service.publish(convertible)

    result = try await service.exists(with: convertible.id, type(of: convertible))
    XCTAssertTrue(result, "Remote model does not exist after publishing.")
  }

  func testUnpublishing() async throws {
    let convertible: T1 = try await service.publish(T1.example, .example).collect()[0]
    
    var result = try await service.exists(with: convertible.id, type(of: convertible))
    XCTAssertTrue(result, "Remote model does not exist after publishing.")

    try await service.unpublish(with: convertible.id, type(of: convertible))

    result = try await service.exists(with: convertible.id, type(of: convertible))
    XCTAssertFalse(result, "Remote model still exists after unpublishing.")
  }

  func testFetching() async throws {
    try await service.publish(createHeterogenousTestData(10, T1.self, T2.self)).collect()

    let result = try await service.fetchAndCollect(Query<T1>(true))
    XCTAssertFalse(result.isEmpty, "No projects were fetched.")
  }
}
