//	Created by Leopold Lemmermann on 14.11.22.

import CloudKit

public typealias CKQueryOperationResult =  (
  matchResults: [(CKRecord.ID, Result<CKRecord, Error>)],
  queryCursor: CKQueryOperation.Cursor?
)

public protocol CKDatabase {
  func record(for: CKRecord.ID) async throws -> CKRecord
  
  func records(matching: CKQuery, resultsLimit: Int) async throws -> CKQueryOperationResult
  
  func records(continuingMatchFrom: CKQueryOperation.Cursor, resultsLimit: Int) async throws -> CKQueryOperationResult
  
  @discardableResult
  func save(_ record: CKRecord) async throws -> CKRecord
  
  @discardableResult
  func deleteRecord(withID: CKRecord.ID) async throws -> CKRecord.ID
}
