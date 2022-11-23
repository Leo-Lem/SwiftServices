//	Created by Leopold Lemmermann on 22.11.22.

import Foundation

@available(iOS 15, macOS 12, *)
public extension PurchaseError {
  var display: Display? { Display(self) }
  
  enum Display: LocalizedError {
    case unverified
    
    public init?(_ base: PurchaseError) {
      switch base {
      case .unverified:
        self = .unverified
      default:
        return nil
      }
    }
    
    public var errorDescription: String? { String(localized: .init(key), bundle: .module) }
    
    public var key: String {
      switch self {
      case .unverified:
        return "TRANSACTION_UNVERIFIED"
      }
    }
  }
}
