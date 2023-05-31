import Concurrency
import Foundation

/// Conforming services can provide information about, and exeucte In-App Purchases
public protocol InAppPurchaseService: EventDriver, ObservableObject where Event == PurchaseEvent<PurchaseID> {
  /// The associated type of purchase id.
  associatedtype PurchaseID: PurchaseIdentifiable

  /// Retrieves all purchases, or alternatively all purchased purchases
  /// - Parameter isPurchasedOnly: A `Bool` which represents the option to filter for purchased purchases only.
  /// - Returns: An `Array` of ``Purchase``.
  func getPurchases(isPurchasedOnly: Bool) -> [Purchase<PurchaseID>]

  /// Purchases the purchase associated with the provided ID.
  /// - Parameter id: The ``PurchaseID`` of the purchase.
  /// - Returns: A ``PurchaseResult``.
  /// - Throws: A ``PurchaseError``, if the purchase fails.
  func purchase(with id: PurchaseID) async throws -> PurchaseResult
}

// default parameter

public extension InAppPurchaseService {
  func getPurchases(isPurchasedOnly: Bool = false) -> [Purchase<PurchaseID>] {
    getPurchases(isPurchasedOnly: isPurchasedOnly)
  }
}
