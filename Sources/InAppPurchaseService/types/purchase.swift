//	Created by Leopold Lemmermann on 20.10.22.

import Foundation

public protocol PurchaseIdentifiable: RawRepresentable<String> & CaseIterable & Hashable {}

public struct Purchase<PurchaseID: PurchaseIdentifiable>: Identifiable {
  public let id: PurchaseID,
             name: String,
             desc: String,
             price: Decimal
  
  public init(
    id: PurchaseID,
    name: String,
    desc: String,
    price: Decimal
  ) {
    self.id = id
    self.name = name
    self.desc = desc
    self.price = price
  }
}

public extension Purchase {
  enum Result {
    case success, pending, cancelled
  }
}
