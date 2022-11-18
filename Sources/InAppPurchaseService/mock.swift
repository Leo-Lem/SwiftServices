//	Created by Leopold Lemmermann on 20.10.22.

import Combine
import Concurrency
import Previews

open class MockPurchaseService<PurchaseID>: InAppPurchaseService
where PurchaseID: RawRepresentable<String> & CaseIterable {
  public let didChange = PassthroughSubject<PurchaseChange, Never>()

  var purchases = [Purchase]()
  var purchased = [Purchase]()
  
  public init() {
    purchases = PurchaseID.allCases.map(Self.examplePurchase)
    purchases.first.flatMap { purchased.append($0) }
  }
  
  public func getPurchases(isPurchased: Bool) -> [Purchase] {
    isPurchased ? self.purchased : self.purchases
  }

  public func purchase(id: PurchaseID) async -> Purchase.Result {
    await sleep(for: .seconds(1))
    purchases
      .first { $0.id == id.rawValue }
      .flatMap { purchased.append($0) }
    return .success
  }
  
  private static func examplePurchase(with id: MockPurchaseService.PurchaseID) -> Purchase {
    Purchase(
      id: id.rawValue,
      name: .random(in: 10 ..< 25, using: .letters),
      desc: .random(in: 15 ..< 50, using: .letters.union(.whitespaces)) + ".",
      price: .init((100 * Double.random(in: 1 ..< 20)) / 100)
    )
  }
}
