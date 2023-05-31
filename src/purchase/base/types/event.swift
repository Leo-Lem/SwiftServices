//	Created by Leopold Lemmermann on 17.11.22.

/// The possible change messages emitted by the ``InAppPurchaseService``.
public enum PurchaseEvent<PurchaseID: PurchaseIdentifiable> {
  /// Added a new purchase.
  case added(Purchase<PurchaseID>)
  /// Removed a purchase.
  case removed(Purchase<PurchaseID>)
  /// Purchased a purchase.
  case purchased(Purchase<PurchaseID>)
}
