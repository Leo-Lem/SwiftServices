//	Created by Leopold Lemmermann on 18.11.22.

import Errors
import Concurrency
import StoreKit

@available(iOS 15, macOS 12, *)
extension StoreKitService {
  func fetchProducts(for purchaseIDs: [PurchaseID]) async {
    let rawIDs = await purchaseIDs.map(\.rawValue)
    
    await printError {
      products = Set(try await Product.products(for: rawIDs))

      for product in products {
        try await product.latestTransaction
          .flatMap(handleTransaction)
      }
    }
  }
}
