//  Created by Leopold Lemmermann on 09.11.22.

@testable import CloudKitService
import DatabaseServiceTests

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
final class CloudKitServiceTests: BaseTests<CloudKitService, Example1, Example2> {
  override func setUp() async throws {
    service = CloudKitService(container: MockCloudKitContainer())

    // verifies the service can be used before starting
    let timeout = Date.now + 3
    repeat {
      try? await Task.sleep(nanoseconds: 1000)
    } while service.status != .available && .now < timeout
    
    guard service.status == .available else { throw XCTSkip("Service is unavailable.") }

    // cleans up any leftover data
    try await service.deleteAll(Example1.self)
    try await service.deleteAll(Example2.self)
  }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
class MockCloudKitContainer: CloudKitContainer {
  private let database = MockCloudKitDatabase(),
              status = CKAccountStatus.available

  init() {}

  func database(with databaseScope: CloudKitDatabaseScope) -> CloudKitDatabase { database }

  func accountStatus() -> CKAccountStatus { status }
}

class MockCloudKitDatabase: CloudKitDatabase {
  private var store = [CKRecord]()

  init() {}

  func record(for recordID: CKRecord.ID) async throws -> CKRecord {
    guard let record = store.first(where: { $0.recordID == recordID }) else {
      throw CKError(.unknownItem)
    }

    return record
  }

  func records(
    matching query: CKQuery,
    inZoneWith: CKRecordZone.ID? = nil,
    desiredKeys: [CKRecord.FieldKey]? = nil,
    resultsLimit: Int = CKQueryOperation.maximumResults
  ) async throws -> (
    matchResults: [(CKRecord.ID, Result<CKRecord, Error>)],
    queryCursor: CKQueryOperation.Cursor?
  ) {
    let matches = store.filter { record in
      record.recordType == query.recordType && query.predicate.evaluate(with: record)
    }

    let result = Array(matches.map { match in
      (match.recordID, Result<CKRecord, Error>(catching: { match }))
    }.prefix(resultsLimit))

    return (result, nil)
  }

  func records(
    continuingMatchFrom cursor: CKQueryOperation.Cursor,
    desiredKeys: [CKRecord.FieldKey]? = nil,
    resultsLimit: Int = CKQueryOperation.maximumResults
  ) async throws -> (
    matchResults: [(CKRecord.ID, Result<CKRecord, Error>)],
    queryCursor: CKQueryOperation.Cursor?
  ) {
    // haven't found a way to initialize the cursor yet
    ([], nil)
  }

  func save(_ record: CKRecord) async throws -> CKRecord {
    store.append(record)

    return record
  }

  func deleteRecord(withID recordID: CKRecord.ID) async throws -> CKRecord.ID {
    store.removeAll { $0.recordID == recordID }

    return recordID
  }
}
