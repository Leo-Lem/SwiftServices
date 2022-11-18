//	Created by Leopold Lemmermann on 18.11.22.

public extension InAppPurchaseService {
  func isPurchased<ID: PurchaseID>(id: ID) -> Bool {
    getPurchases(isPurchased: true)
      .contains { $0.id == id.rawValue }
  }
}
