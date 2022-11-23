//	Created by Leopold Lemmermann on 23.11.22.

import Combine
import InAppPurchaseService

public extension AnyInAppPurchaseService {
  static var mock: Self {
    Self(MockInAppPurchaseService())
  }
  
  @available(iOS 15, macOS 12, *)
  static func storekit() async -> Self {
    Self(await StoreKitService())
  }
}

open class AnyInAppPurchaseService<PurchaseID: PurchaseIdentifiable>: InAppPurchaseService {
  public let didChange: PassthroughSubject<PurchaseChange<PurchaseID>, Never>
  public func getPurchases(isPurchased: Bool) -> [Purchase<PurchaseID>] { getPurchases(isPurchased) }
  public func purchase(with id: PurchaseID) async throws -> Purchase<PurchaseID>.Result { try await purchase(id) }
  
  internal let getPurchases: (_ isPurchased: Bool) -> [Purchase<PurchaseID>]
  internal let purchase: (_ id: PurchaseID) async throws -> Purchase<PurchaseID>.Result
  
  public required init<S: InAppPurchaseService>(_ service: S) where S.PurchaseID == PurchaseID {
    didChange = service.didChange
    getPurchases = service.getPurchases
    purchase = service.purchase
  }
}
