//	Created by Leopold Lemmermann on 18.11.22.

import InAppPurchaseService
import StoreKit

@available(iOS 15, macOS 12, *)
extension StoreKitService {
  func handleError<T>(_ throwing: () throws -> T) throws -> T {
    do {
      return try throwing()
    } catch let error as Product.PurchaseError {
      throw PurchaseError.purchase(error)
    } catch {
      throw PurchaseError.other(error)
    }
  }
  
  @_disfavoredOverload
  func handleError<T>(_ throwing: () async throws -> T) async throws -> T {
    do {
      return try await throwing()
    } catch let error as Product.PurchaseError {
      throw PurchaseError.purchase(error)
    } catch {
      throw PurchaseError.other(error)
    }
  }
}
