
import Combine

public protocol InAppPurchaseService {
  associatedtype PurchaseID: PurchaseIdentifiable
  
  var didChange: PassthroughSubject<PurchaseChange<PurchaseID>, Never> { get }
  
  func getPurchases(isPurchased: Bool) -> [Purchase<PurchaseID>]
  func purchase(with id: PurchaseID) async throws -> Purchase<PurchaseID>.Result
}
