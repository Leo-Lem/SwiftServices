//	Created by Leopold Lemmermann on 23.11.22.

import Combine
import InAppPurchaseService

@available(iOS 15, macOS 12, *)
open class AnyInAppPurchaseService<PurchaseID: PurchaseIdentifiable>: InAppPurchaseService {
  public let didChange: PassthroughSubject<PurchaseChange<PurchaseID>, Never>

  private let service: Any
  public init<S: InAppPurchaseService>(_ service: S) where PurchaseID == S.PurchaseID {
    self.service = service
    
    if let service = service as? StoreKitService<PurchaseID> {
      didChange = service.didChange
    } else if let service = service as? MockInAppPurchaseService<PurchaseID> {
      didChange = service.didChange
    } else {
      fatalError("Incompatible service provided.")
    }
  }

  public func getPurchases(isPurchased: Bool) -> [Purchase<PurchaseID>] {
    if let service = service as? StoreKitService<PurchaseID> {
      return service.getPurchases(isPurchased: isPurchased)
    } else if let service = service as? MockInAppPurchaseService<PurchaseID> {
      return service.getPurchases(isPurchased: isPurchased)
    } else {
      fatalError("Incompatible service provided.")
    }
  }

  public func purchase(with id: PurchaseID) async throws -> Purchase<PurchaseID>.Result {
    if let service = service as? StoreKitService<PurchaseID> {
      return try await service.purchase(with: id)
    } else if let service = service as? MockInAppPurchaseService<PurchaseID> {
      return try await service.purchase(with: id)
    } else {
      fatalError("Incompatible service provided.")
    }
  }
}
