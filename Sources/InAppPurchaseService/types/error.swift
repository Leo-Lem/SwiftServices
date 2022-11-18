//	Created by Leopold Lemmermann on 18.11.22.

public enum PurchaseError: Error {
  case unverified,
       purchase(Error),
       other(Error?)
}
