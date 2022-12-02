//	Created by Leopold Lemmermann on 22.11.22.

import Foundation

@available(iOS 15, macOS 12, *)
extension PurchaseError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .unverified:
      return String(localized: "TRANSACTION_UNVERIFIED", bundle: .module)
    case .unavailable:
      return String(localized: "PURCHASE_UNAVAILABLE", bundle: .module)
    default:
      return nil
    }
  }
}
