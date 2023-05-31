//	Created by Leopold Lemmermann on 18.11.22.

public extension InAppPurchaseService {
  func isPurchased(with id: PurchaseID) -> Bool {
    getPurchases(isPurchasedOnly: true).contains { $0.id == id }
  }
}
