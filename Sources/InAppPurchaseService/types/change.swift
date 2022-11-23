//	Created by Leopold Lemmermann on 17.11.22.

public enum PurchaseChange<PurchaseID: PurchaseIdentifiable> {
  case added(Purchase<PurchaseID>),
       removed(Purchase<PurchaseID>),
       purchased(Purchase<PurchaseID>)
}
