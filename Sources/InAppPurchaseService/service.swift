
import Combine

public protocol InAppPurchaseService {
  associatedtype PurchaseID: RawRepresentable<String> & CaseIterable
  
  var didChange: PassthroughSubject<PurchaseChange, Never> { get }
  
  func getPurchases(isPurchased: Bool) -> [Purchase]
  func purchase(id: PurchaseID) async -> Purchase.Result
}
