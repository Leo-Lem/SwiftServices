//	Created by Leopold Lemmermann on 22.11.22.

import Foundation

@available(iOS 15, macOS 12, *)
extension DatabaseError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case let .status(status) where status == .readOnly:
      return String(localized: "DATABASE_READONLY_ERROR", bundle: .module)
    case let .status(status) where status == .unavailable:
      return String(localized: "DATABASE_UNAVAILABLE_ERROR", bundle: .module)
    default:
      return nil
    }
  }
}
