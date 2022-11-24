//	Created by Leopold Lemmermann on 14.11.22.

import CloudKit

extension CKContainer: CloudKitContainer {}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public protocol CloudKitContainer {
  func database(with databaseScope: CloudKitDatabaseScope) -> CloudKitDatabase
  func accountStatus() async throws -> CKAccountStatus
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension CloudKitContainer where Self: CKContainer {
  func database(with databaseScope: CloudKitDatabaseScope) -> CloudKitDatabase {
    database(with: CKDatabase.Scope(from: databaseScope))
  }
}

public enum CloudKitDatabaseScope: Int, @unchecked Sendable {
  case `public`,
       shared,
       `private`
}

public extension CloudKit.CKDatabase.Scope {
  init(from scope: CloudKitDatabaseScope) {
    switch scope {
    case .public: self = .public
    case .shared: self = .shared
    case .private: self = .private
    }
  }
}
