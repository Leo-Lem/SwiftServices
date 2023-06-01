//	Created by Leopold Lemmermann on 14.11.22.

extension CKContainer: CloudKitContainer {}

public protocol CloudKitContainer {
  func database(with databaseScope: CloudKitDatabaseScope) -> CloudKitDatabase
  func accountStatus() async throws -> CKAccountStatus
}

public extension CloudKitContainer where Self: CKContainer {
  func database(with databaseScope: CloudKitDatabaseScope) -> CloudKitDatabase {
    switch databaseScope {
    case .public: return database(with: .public)
    case .shared: return database(with: .shared)
    case .private: return database(with: .private)
    }
  }
}

public enum CloudKitDatabaseScope: Int, @unchecked Sendable {
  case `public`, shared, `private`
}
