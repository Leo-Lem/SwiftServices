//	Created by Leopold Lemmermann on 18.11.22.

public extension InAppPurchaseService {
  func getPurchase<ID: PurchaseID>(id: ID) -> Purchase? {
    getPurchases(isPurchased: false)
      .first { $0.id == id.rawValue }
  }
}
