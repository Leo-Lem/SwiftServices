//	Created by Leopold Lemmermann on 20.10.22.

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension Purchase {
  init?(product: Product) {
    guard let id = PurchaseID(rawValue: product.id) else { return nil }
    
    self.init(id, name: product.displayName, desc: product.description, price: product.price)
  }
}
