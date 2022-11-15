//	Created by Leopold Lemmermann on 15.11.22.

import CloudKit

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
