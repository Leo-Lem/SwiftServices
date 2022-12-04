//	Created by Leopold Lemmermann on 17.11.22.

import Concurrency
import class Combine.PassthroughSubject

@available(iOS 15, macOS 12, *)
public extension InAppPurchaseService {
  var events: AsyncStream<PurchaseChange<PurchaseID>> { eventPublisher.stream }
}

/// The publisher for changes in the ``InAppPurchaseService``.
public typealias PurchaseChangePublisher<PurchaseID: PurchaseIdentifiable> =
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
