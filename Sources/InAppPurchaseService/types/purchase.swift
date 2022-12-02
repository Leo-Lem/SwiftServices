//	Created by Leopold Lemmermann on 20.10.22.

import Foundation

/// Conforming types can be used to identify a purchase.
public protocol PurchaseIdentifiable: RawRepresentable<String> & CaseIterable & Hashable {}

/// Representation of a possible purchase (product).
public struct Purchase<PurchaseID: PurchaseIdentifiable>: Identifiable {
  
  /// The purchase ID associated with the purchase.
  public let id: PurchaseID
  /// The display name of the purchase.
  public let name: String
  /// A short description of the purchase.
  public let desc: String
  /// The price of the purchase as `Decimal`.
  public let price: Decimal
  
  /// The default initializer of a purchase.
  /// - Parameters:
  ///   - id: The generic `PurchaseID` associated with the purchase.
  ///   - name: A `String` containing the display name of the purchase.
  ///   - desc: A `String` containing a short description of the purchase.
  ///   - price: A `Decimal` describing the purchase price.
  public init(_ id: PurchaseID, name: String, desc: String, price: Decimal) {
    self.id = id
    self.name = name
    self.desc = desc
    self.price = price
  }
}
