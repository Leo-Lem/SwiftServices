
import Concurrency
import Errors
@_exported import InAppPurchaseService
@_exported import StoreKit

public extension AnyInAppPurchaseService {
  @available(iOS 15, macOS 12, *)
  static func storekit() async -> Self { Self(await StoreKitService()) }
}

@available(iOS 15, macOS 12, *)
open class StoreKitService<PurchaseID: PurchaseIdentifiable>: InAppPurchaseService {
  public let eventPublisher = Publisher<PurchaseEvent<PurchaseID>>()

  var products = Set<Product>()
  var purchased = Set<Product>()

  let tasks = Tasks()

  public init() async {
    await fetchProducts(for: Array(PurchaseID.allCases))

    tasks["updateOnRemoteChange"] = Task(priority: .background) {
      await printError {
        for await verification in Transaction.updates {
          try handleTransaction(verification)
        }
      }
    }
  }

  public func getPurchases(isPurchasedOnly: Bool = false) -> [Purchase<PurchaseID>] {
    (isPurchasedOnly ? purchased : products).compactMap(Purchase<PurchaseID>.init)
  }

  public func purchase(with id: PurchaseID) async throws -> PurchaseResult {
    guard let product = products.first(where: { $0.id == id.rawValue }) else { throw PurchaseError.unavailable }

    switch try await product.purchase() {
    case let .success(verification):
      try handleTransaction(verification)
      return .success
    case .pending:
      return .pending
    case .userCancelled:
      return .cancelled
    @unknown default:
      throw PurchaseError.other(nil)
    }
  }
}
