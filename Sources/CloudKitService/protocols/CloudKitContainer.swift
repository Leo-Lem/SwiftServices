//	Created by Leopold Lemmermann on 14.11.22.

import CloudKit

public protocol CloudKitContainer {
  func database(with databaseScope: CloudKitDatabaseScope) -> CloudKitDatabase
  func accountStatus() async throws -> CKAccountStatus
}

public extension CloudKitContainer where Self: CKContainer {
  func database(with databaseScope: CloudKitDatabaseScope) -> CloudKitDatabase {
    database(with: CKDatabase.Scope(from: databaseScope))
  }
}

extension CKContainer: CloudKitContainer {}
extension CKDatabase: CloudKitDatabase {}
