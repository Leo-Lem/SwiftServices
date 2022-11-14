//	Created by Leopold Lemmermann on 14.11.22.

import CloudKit

public protocol CKContainer {
  func database(with scope: CloudKit.CKDatabase.Scope) -> CKDatabase
  func accountStatus() async throws -> CKAccountStatus
}
