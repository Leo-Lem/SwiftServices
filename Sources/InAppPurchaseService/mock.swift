//	Created by Leopold Lemmermann on 20.10.22.

import Previews

public extension AnyInAppPurchaseService {
  static var mock: Self { Self(MockInAppPurchaseService()) }
}

open class MockInAppPurchaseService<PurchaseID: PurchaseIdentifiable>: InAppPurchaseService {
  public let didChange = DidChangePublisher<PurchaseID>()

  internal var purchases = [Purchase<PurchaseID>]()
  internal var purchased = [Purchase<PurchaseID>]()

  public init() {
    purchases = PurchaseID.allCases.map(Self.examplePurchase)
  }

  public func getPurchases(isPurchasedOnly: Bool = false) -> [Purchase<PurchaseID>] {
    isPurchasedOnly ? self.purchased : self.purchases
  }

  public func purchase(with id: PurchaseID) async throws -> PurchaseResult {
    guard let purchase = purchases.first(where: { $0.id == id }) else {
      throw PurchaseError.other(nil)
    }

    purchased.append(purchase)
    return .success
  }
}

internal extension MockInAppPurchaseService {
  static func examplePurchase(with id: PurchaseID) -> Purchase<PurchaseID> {
    Purchase(
      id,
      name: .random(in: 10 ..< 25, using: .letters).localizedCapitalized,
      desc: .random(in: 15 ..< 50, using: .letters.union(.whitespaces)).localizedCapitalized + ".",
      price: .init(Double(Int.random(in: 0..<99)) + 0.99)
    )
  }
}
