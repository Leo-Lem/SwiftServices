//	Created by Leopold Lemmermann on 17.11.22.

import class Combine.PassthroughSubject

/// The publisher for changes in the ``InAppPurchaseService``.
public typealias DidChangePublisher<PurchaseID: PurchaseIdentifiable> =
  PassthroughSubject<PurchaseChange<PurchaseID>, Never>

/// The possible change messages emitted by the ``InAppPurchaseService``.
public enum PurchaseChange<PurchaseID: PurchaseIdentifiable> {
  /// Added a new purchase.
  case added(Purchase<PurchaseID>)
  /// Removed a purchase.
  case removed(Purchase<PurchaseID>)
  /// Purchased a purchase.
  case purchased(Purchase<PurchaseID>)
}
