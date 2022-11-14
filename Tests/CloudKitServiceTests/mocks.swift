//	Created by Leopold Lemmermann on 14.11.22.

import CloudKit
import protocol CloudKitService.CKContainer
import protocol CloudKitService.CKDatabase
import typealias CloudKitService.CKQueryOperationResult

class MockCKContainer: CKContainer {
  private let database = MockCKDatabase(),
              status = CKAccountStatus.available

  init() {}

  func database(with scope: CloudKit.CKDatabase.Scope) -> CKDatabase { database }

  func accountStatus() -> CKAccountStatus { status }
}

class MockCKDatabase: CKDatabase {
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
    resultsLimit: Int = CKQueryOperation.maximumResults
  ) async throws -> CKQueryOperationResult {
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
    resultsLimit: Int = CKQueryOperation.maximumResults
  ) async throws -> CKQueryOperationResult {
    // haven't found a way to initiaize the cursor yet
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
