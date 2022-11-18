//	Created by Leopold Lemmermann on 18.11.22.

public extension InAppPurchaseService {
  func getIDs(isPurchased: Bool) -> [PurchaseID] {
    getPurchases(isPurchased: isPurchased)
      .map(\.id)
      .compactMap(PurchaseID.init)
  }
}
