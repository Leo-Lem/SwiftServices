//	Created by Leopold Lemmermann on 18.11.22.

import InAppPurchaseService
import StoreKit

@available(iOS 15, macOS 12, *)
extension StoreKitService {
  func handleTransaction(_ verification: VerificationResult<Transaction>) throws {
    guard case let .verified(transaction) = verification else { throw PurchaseError.unverified }

    if transaction.revocationDate != nil {
      purchased = purchased.filter { $0.id != transaction.productID }
    } else if let expirationDate = transaction.expirationDate, expirationDate < Date() {
      return
    } else if transaction.isUpgraded {
      return
    } else if let product = products.first(where: { $0.id == transaction.productID }) {
      didChange.send(.purchased(.init(product: product)))
      purchased.insert(product)
    }
  }
}
