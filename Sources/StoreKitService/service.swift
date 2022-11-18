
import Combine
import Concurrency
import Errors
import InAppPurchaseService
import StoreKit

@available(iOS 15, macOS 12, *)
open class StoreKitService<PurchaseID>: InAppPurchaseService
  where PurchaseID: RawRepresentable<String> & CaseIterable
{
  public let didChange = PassthroughSubject<PurchaseChange, Never>()

  var products = Set<Product>()
  var purchased = Set<Product>()

  let tasks = Tasks()

  public init() async {
    await getProducts(Array(PurchaseID.allCases))
    tasks.add(reactToUpdates())
  }

  public func getPurchases(isPurchased: Bool) -> [Purchase] {
    (isPurchased ? purchased : products)
      .map(Purchase.init)
  }

  public func purchase(id: PurchaseID) async -> Purchase.Result {
    let product = products.first { $0.id == id.rawValue }!

    do {
      let result = try await product.purchase()
      return mapToPurchaseResult(result)
    } catch let error as Product.PurchaseError {
      return .failed(error)
    } catch {
      print("Failed to purchase product (\(product.debugDescription)): \(error.localizedDescription)")
      return .failed()
    }
  }
}

@available(iOS 15, macOS 12, *)
private extension StoreKitService {
  func reactToUpdates() -> Task<Void, Never> {
    Task(priority: .background) {
      for await verificationResult in Transaction.updates {
        handle(transaction: verificationResult)
      }
    }
  }

  func getProducts(_ purchases: [PurchaseID]) async {
    await printError {
      products = Set(try await Product.products(for: purchases.map(\.rawValue)))

      for product in products {
        if let verificationResult = await product.latestTransaction {
          handle(transaction: verificationResult)
        }
      }
    }
  }

  func handle(transaction: VerificationResult<Transaction>) {
    guard case let .verified(transaction) = transaction else { return }

    if transaction.revocationDate != nil {
      purchased = purchased.filter { $0.id != transaction.productID }
    } else if let expirationDate = transaction.expirationDate, expirationDate < Date() {
      return
    } else if transaction.isUpgraded {
      return
    } else if let product = products.first(where: { $0.id == transaction.productID }) {
      didChange.send(.purchased(.init(product: product)))
      purchased.insert(product)
    }
  }

  func mapToPurchaseResult(_ result: Product.PurchaseResult) -> Purchase.Result {
    switch result {
    case let .success(verification):
      handle(transaction: verification)
      return .success
    case .pending:
      return .pending
    case .userCancelled:
      return .cancelled
    default:
      return .failed()
    }
  }
}
