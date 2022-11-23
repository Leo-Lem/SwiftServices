//	Created by Leopold Lemmermann on 18.11.22.

public extension InAppPurchaseService {
  func getPurchase(with id: PurchaseID) -> Purchase<PurchaseID>? {
    getPurchases(isPurchased: false)
      .first { $0.id == id }
  }
}
