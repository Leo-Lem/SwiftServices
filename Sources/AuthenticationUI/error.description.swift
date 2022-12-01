//	Created by Leopold Lemmermann on 05.11.22.

import protocol Foundation.LocalizedError

@available(iOS 15, macOS 12, *)
extension AuthenticationError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .noConnection:
      return String(localized: "NO_CONNECTION", bundle: .module)
    case .registrationIDTaken:
      return String(localized: "ID_TAKEN", bundle: .module)
    case .registrationInvalidID:
      return String(localized: "ID_INVALID", bundle: .module)
    case .authenticationWrongPIN:
      return String(localized: "PIN_WRONG", bundle: .module)
    default:
      return nil
    }
  }
}
