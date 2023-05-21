//	Created by Leopold Lemmermann on 18.11.22.

import Errors

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension StoreKitService {
  func fetchProducts<ID: PurchaseIdentifiable>(for purchaseIDs: [ID]) async {
    await printError {
      products = Set(try await Product.products(for: await purchaseIDs.map(\.rawValue)))

      for product in products {
        try await product.latestTransaction.flatMap(handleTransaction)
      }
    }
  }
}
