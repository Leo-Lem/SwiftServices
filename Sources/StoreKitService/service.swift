
import Combine
import Concurrency
import Errors
import InAppPurchaseService
import StoreKit

@available(iOS 15, macOS 12, *)
open class StoreKitService<PurchaseID: PurchaseIdentifiable>: InAppPurchaseService {
  public let didChange = PassthroughSubject<PurchaseChange<PurchaseID>, Never>()

  var products = Set<Product>()
  var purchased = Set<Product>()

  let tasks = Tasks()

  public init() async {
    await fetchProducts(for: Array(PurchaseID.allCases))
    tasks.add(updateOnRemoteChange())
  }

  public func getPurchases(isPurchased: Bool) -> [Purchase<PurchaseID>] {
    (isPurchased ? purchased : products)
      .compactMap(Purchase<PurchaseID>.init)
  }

  public func purchase(with id: PurchaseID) async throws -> Purchase<PurchaseID>.Result {
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
