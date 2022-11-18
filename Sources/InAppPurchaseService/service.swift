
import Combine

public protocol InAppPurchaseService {
  var didChange: PassthroughSubject<PurchaseChange, Never> { get }
  
  func getPurchases(isPurchased: Bool) -> [Purchase]
  func purchase<ID: PurchaseID>(id: ID) async throws -> Purchase.Result
}
