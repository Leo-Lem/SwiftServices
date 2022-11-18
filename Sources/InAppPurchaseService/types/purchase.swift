//	Created by Leopold Lemmermann on 20.10.22.

import Foundation

public struct Purchase: Identifiable {
  public let id: String,
             name: String,
             desc: String,
             price: Decimal
  
  public init(
    id: String,
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
  func getPurchaseID<ID: PurchaseIdentifiable>() -> ID? { ID(rawValue: id) }
}
