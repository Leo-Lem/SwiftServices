
import Combine
import Concurrency
import Errors
import InAppPurchaseService
import StoreKit

@available(iOS 15, macOS 12, *)
open class StoreKitService<PurchaseID: RawRepresentable<String> & CaseIterable>: InAppPurchaseService {
  public let didChange = PassthroughSubject<PurchaseChange, Never>()

  var products = Set<Product>()
  var purchased = Set<Product>()

  let tasks = Tasks()

  public init() async {
    await fetchProducts(for: Array(PurchaseID.allCases))
    tasks.add(updateOnRemoteChange())
  }

  public func getPurchases(isPurchased: Bool) -> [Purchase] {
    (isPurchased ? purchased : products)
      .map(Purchase.init)
  }

  public func purchase(id: PurchaseID) async throws -> Purchase.Result {
    try await handleError {
      let product = products.first { $0.id == id.rawValue }!
      let result = try await product.purchase()

      if case let .success(verification) = result {
        try handleTransaction(verification)
      }

      return try Purchase.Result(result: result)
    }
  }
}
