//	Created by Leopold Lemmermann on 02.12.22.

open class AnyInAppPurchaseService<PurchaseID: PurchaseIdentifiable>: InAppPurchaseService {
  public let eventPublisher: PurchaseChangePublisher<PurchaseID>
  
  public func getPurchases(isPurchasedOnly: Bool = false) -> [Purchase<PurchaseID>] { getPurchases(isPurchasedOnly) }
  public func purchase(with id: PurchaseID) async throws -> PurchaseResult { try await purchase(id) }
  
  internal let getPurchases: (_ isPurchasedOnly: Bool) -> [Purchase<PurchaseID>]
  internal let purchase: (_ id: PurchaseID) async throws -> PurchaseResult
  
  public required init<S: InAppPurchaseService>(_ service: S) where S.PurchaseID == PurchaseID {
    eventPublisher = service.eventPublisher
    getPurchases = service.getPurchases
    purchase = service.purchase
  }
}
