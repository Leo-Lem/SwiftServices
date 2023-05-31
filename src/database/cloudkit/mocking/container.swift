//	Created by Leopold Lemmermann on 14.11.22.

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension CKContainer: CloudKitContainer {}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public protocol CloudKitContainer {
  func database(with databaseScope: CloudKitDatabaseScope) -> CloudKitDatabase
  func accountStatus() async throws -> CKAccountStatus
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
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
