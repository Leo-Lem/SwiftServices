//	Created by Leopold Lemmermann on 20.10.22.

import Previews
import InAppPurchaseService

extension Purchase: HasExample {
  public static var example: Purchase {
    Purchase(
      id: .random(in: 10 ..< 25, using: .letters),
      name: .random(in: 10 ..< 25, using: .letters),
      desc: .random(in: 15 ..< 50, using: .letters.union(.whitespaces)) + ".",
      price: .init((100 * Double.random(in: 1 ..< 20)) / 100)
    )
  }
}
