//	Created by Leopold Lemmermann on 20.10.22.

import Combine
import Previews

open class MockInAppPurchaseService: InAppPurchaseService {
  public let didChange = PassthroughSubject<PurchaseChange, Never>()

  var purchases = [Purchase]()
  var purchased = [Purchase]()

  public init<ID: PurchaseIdentifiable>(_: ID.Type) {
    purchases = ID.allCases.map(Self.examplePurchase)
    purchases.first.flatMap { purchased.append($0) }
  }

  public func getPurchases(isPurchased: Bool) -> [Purchase] {
    isPurchased ? self.purchased : self.purchases
  }

  public func purchase<ID: PurchaseIdentifiable>(id: ID) async throws -> Purchase.Result {
    guard let purchase = purchases.first(where: { $0.id == id.rawValue }) else {
      throw PurchaseError.other(nil)
    }

    purchased.append(purchase)
    return .success
  }
}

extension MockInAppPurchaseService {
  static func examplePurchase<ID: PurchaseIdentifiable>(with id: ID) -> Purchase {
    Purchase(
      id: id.rawValue,
      name: .random(in: 10 ..< 25, using: .letters),
      desc: .random(in: 15 ..< 50, using: .letters.union(.whitespaces)) + ".",
      price: .init((100 * Double.random(in: 1 ..< 20)) / 100)
    )
  }
}
