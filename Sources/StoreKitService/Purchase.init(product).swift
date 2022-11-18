//	Created by Leopold Lemmermann on 20.10.22.

import InAppPurchaseService
import StoreKit

@available(iOS 15, macOS 12, *)
extension Purchase {
  init(product: Product) {
    self.init(
      id: product.id,
      name: product.displayName,
      desc: product.description,
      price: product.price
    )
  }
}
