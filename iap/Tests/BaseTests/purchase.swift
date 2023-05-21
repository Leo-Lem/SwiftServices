//	Created by Leopold Lemmermann on 20.10.22.

import Previews

extension Purchase: HasExample where PurchaseID == ExamplePurchaseID {
   public static var example: Purchase {
    Purchase(
      ExamplePurchaseID.fullVersion,
      name: .random(in: 10 ..< 25, using: .letters),
      desc: .random(in: 15 ..< 50, using: .letters.union(.whitespaces)) + ".",
      price: .init((100 * Double.random(in: 1 ..< 20)) / 100)
    )
  }
}

public enum ExamplePurchaseID: String, PurchaseIdentifiable {
  case fullVersion = "InAppPurchaseService.fullVersion"
}
