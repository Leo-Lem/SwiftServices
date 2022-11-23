//	Created by Leopold Lemmermann on 22.11.22.

import Foundation

@available(iOS 15, macOS 12, *)
public extension RemoteDatabaseError {
  var display: Display? { Display(self) }

  enum Display: LocalizedError {
    case notAuthenticated,
         noNetwork,
         rateLimited

    public init?(_ base: RemoteDatabaseError) {
      switch base {
      case .notAuthenticated:
        self = .notAuthenticated
      case .noNetwork:
        self = .noNetwork
      case .rateLimited:
        self = .rateLimited
      default:
        return nil
      }
    }

    public var errorDescription: String? { String(localized: .init(key), bundle: .module) }
    public var key: String {
      switch self {
      case .noNetwork:
        return "CONNECTION_ERROR"
      case .notAuthenticated:
        return "AUTH_ERROR"
      case .rateLimited:
        return "RATE_ERROR"
      }
    }
  }
}
