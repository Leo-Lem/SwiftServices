//	Created by Leopold Lemmermann on 05.11.22.

import Foundation

@available(iOS 15, macOS 12, *)
extension AuthenticationError: LocalizedError {
  public var localizationKey: String? {
    switch self {
    case .noConnection:
      return "NO_CONNECTION"
    case .registrationIDTaken:
      return "ID_TAKEN"
    case .registrationInvalidID:
      return "ID_INVALID"
    case .modificationInvalidNewPIN:
      return "NEW_PIN_INVALID"
    case .authenticationWrongPIN:
      return "PIN_WRONG"
    default:
      return nil
    }
  }
  
  public var errorDescription: String? {
    localizationKey.flatMap { String(localized: .init($0)) }
  }
}
