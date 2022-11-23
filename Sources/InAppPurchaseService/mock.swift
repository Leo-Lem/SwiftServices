//	Created by Leopold Lemmermann on 20.10.22.

import Combine
import Previews

open class MockInAppPurchaseService<PurchaseID: PurchaseIdentifiable>: InAppPurchaseService {
  public let didChange = PassthroughSubject<PurchaseChange<PurchaseID>, Never>()

  var purchases = [Purchase<PurchaseID>]()
  var purchased = [Purchase<PurchaseID>]()

  public init() {
    purchases = PurchaseID.allCases.map(Self.examplePurchase)
  }

  public func getPurchases(isPurchased: Bool) -> [Purchase<PurchaseID>] {
    isPurchased ? self.purchased : self.purchases
  }

  public func purchase(with id: PurchaseID) async throws -> Purchase<PurchaseID>.Result {
    guard let purchase = purchases.first(where: { $0.id == id }) else {
      throw PurchaseError.other(nil)
    }

    purchased.append(purchase)
    return .success
  }
}

extension MockInAppPurchaseService {
  static func examplePurchase(with id: PurchaseID) -> Purchase<PurchaseID> {
    Purchase(
      id: id,
      name: .random(in: 10 ..< 25, using: .letters),
      desc: .random(in: 15 ..< 50, using: .letters.union(.whitespaces)) + ".",
      price: .init((100 * Double.random(in: 1 ..< 20)) / 100)
    )
  }
}
