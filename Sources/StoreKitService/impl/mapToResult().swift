//	Created by Leopold Lemmermann on 18.11.22.

import StoreKit
import InAppPurchaseService

@available(iOS 15, macOS 12, *)
extension Purchase.Result {
  init(result: Product.PurchaseResult) throws {
    switch result {
    case .success:
      self = .success
    case .pending:
      self = .pending
    case .userCancelled:
      self = .cancelled
    @unknown default:
      throw PurchaseError.other(nil)
    }
  }
}
