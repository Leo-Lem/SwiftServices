//	Created by Leopold Lemmermann on 17.11.22.

public enum PurchaseChange {
  case added(Purchase?),
       removed(Purchase?),
       purchased(Purchase?)
}
