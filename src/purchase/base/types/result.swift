//	Created by Leopold Lemmermann on 18.11.22.

/// The possible result's of purchasing a purchase.
public enum PurchaseResult {
  /// The purchase succeeded.
  case success
  /// The purchase is pending (awaiting approval, for instance).
  case pending
  /// The purchase was cancelled.
  case cancelled
}

/// The possible errors thrown by the ``InAppPurchaseService``'s methods.
public enum PurchaseError: Error {
  /// Purchase couldn't be verified
  case unverified
  /// The purchase can't be found or is otherwise unavailable.
  case unavailable
  /// Another error, which cannot be classified any closer.
  case other(Error?)
}
