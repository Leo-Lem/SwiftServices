//  Created by Leopold Lemmermann on 08.10.22.

@_exported @testable import DatabaseService
@_exported import XCTest

// !!!:  Subclass these tests and insert an implementation to 'service' in the setUp method. (Like the mock tests)
open class BaseTests<S: DatabaseService, T1: Example1Protocol, T2: Example2Protocol>: XCTestCase {
  public var service: S!

  func testInserting() async throws {
    let convertible = T1.example
    var result = try await service.exists(T1.self, with: convertible.id)
    XCTAssertFalse(result, "Database object exists without inserting.")

    try await service.insert(convertible)

    result = try await service.exists(T1.self, with: convertible.id)
    XCTAssertTrue(result, "Database object does not exist after inserting.")
  }

  func testDeleting() async throws {
    let convertible = try await service.insert([T1.example, .example]).collect()[0]

    try await service.delete(T1.self, with: convertible.id)

    let result = try await service.exists(T1.self, with: convertible.id)
    XCTAssertFalse(result, "Database object exists after deleting.")
  }

  func testFetching() async throws {
    let convertible = try await service.insert(T1.example)

    let queries = [
      Query<T1>(\.value, .equal, convertible.value),
      Query<T1>(\.value, .notEqual, convertible.value + 1)
    ]

    for query in queries {
      let result: [T1] = try await service.fetchAndCollect(query)
      XCTAssertTrue(result.contains { $0 == convertible }, "\(query) does not find the \(convertible).")
    }

    let fetched: T1? = try await service.fetch(with: convertible.id)
    XCTAssertEqual(convertible, fetched, "The fetched convertible does not match.")

    try await service.insert(createHeterogenousTestData(10, T1.self, T2.self)).collect()
    let result = try await service.fetchAndCollect(Query<T1>(true))
    XCTAssertFalse(result.isEmpty, "No convertibles were fetched.")
  }

  func testEditing() async throws {
    let convertible = try await service.insert(T1.example)
    let newValue = Int.random(in: 0 ..< 100)

    try await service.insert(T1(id: convertible.id, value: newValue))
    var fetched: T1? = try await service.fetch(with: convertible.id)
    XCTAssertEqual(fetched?.value, newValue, "The modifified database object doesn't match.")

    try await service.modify(T1.self, with: convertible.id) { editable in
      editable.value = newValue
    }

    fetched = try await service.fetch(with: convertible.id)
    XCTAssertEqual(fetched?.value, newValue, "The modifified database object doesn't match.")
  }

  func testCounting() async throws {
    for count in 1 ..< 10 {
      try await service.insert(createTestData(count) as [T1]).collect()
      let fetchedCount = try await service.fetchAndCollect(Query<T1>(true, options: .init(batchSize: count))).count
      XCTAssertEqual(fetchedCount, count, "Count does not match.")
      
      try await service.deleteAll(T1.self)
    }
  }

  @available(iOS 15, macOS 12, *)
  func testUpdates() async throws {
    for datum in createHeterogenousTestData(2, T1.self, T2.self) {
      let task = service.didChange.getTask { change in
        switch change {
        case let .inserted(convertible):
          XCTAssertEqual(
            convertible.id.description, datum.id.description,
            "The inserted model does not match the original."
          )

        case let .deleted(_, id):
          XCTAssertEqual(id.description, datum.id.description, "The deleted model does not match.")

        default:
          break
        }
      }

      try await service.insert(datum)
      try await service.delete(datum)

      task.cancel()
    }
  }
}
