//	Created by Leopold Lemmermann on 14.11.22.

import CloudKit

public protocol CloudKitDatabase {
  func record(for: CKRecord.ID) async throws -> CKRecord

  func records(
    matching query: CKQuery,
    inZoneWith recordZone: CKRecordZone.ID?,
    desiredKeys: [CKRecord.FieldKey]?,
    resultsLimit: Int
  ) async throws -> (
    matchResults: [(CKRecord.ID, Result<CKRecord, Error>)],
    queryCursor: CKQueryOperation.Cursor?
  )

  func records(
    continuingMatchFrom queryCursor: CKQueryOperation.Cursor,
    desiredKeys: [CKRecord.FieldKey]?,
    resultsLimit: Int
  ) async throws -> (
    matchResults: [(CKRecord.ID, Result<CKRecord, Error>)],
    queryCursor: CKQueryOperation.Cursor?
  )

  @discardableResult
  func save(_ record: CKRecord) async throws -> CKRecord

  @discardableResult
  func deleteRecord(withID: CKRecord.ID) async throws -> CKRecord.ID
}

public extension CloudKitDatabase {
  func records(
    matching query: CKQuery,
    inZoneWith recordZone: CKRecordZone.ID? = nil,
    desiredKeys: [CKRecord.FieldKey]? = nil,
    resultsLimit: Int = CKQueryOperation.maximumResults
  ) async throws -> (
    matchResults: [(CKRecord.ID, Result<CKRecord, Error>)],
    queryCursor: CKQueryOperation.Cursor?
  ) {
    try await records(
      matching: query,
      inZoneWith: recordZone,
      desiredKeys: desiredKeys,
      resultsLimit: resultsLimit
    )
  }
  
  func records(
    continuingMatchFrom queryCursor: CKQueryOperation.Cursor,
    desiredKeys: [CKRecord.FieldKey]? = nil,
    resultsLimit: Int = CKQueryOperation.maximumResults
  ) async throws -> (
    matchResults: [(CKRecord.ID, Result<CKRecord, Error>)],
    queryCursor: CKQueryOperation.Cursor?
  ) {
    try await records(
      continuingMatchFrom: queryCursor,
      desiredKeys: desiredKeys,
      resultsLimit: resultsLimit
    )
  }
}
