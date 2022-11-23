//	Created by Leopold Lemmermann on 05.11.22.

import Foundation

@available(iOS 15, macOS 12, *)
public extension AuthenticationError {
  var display: Display? { Display(self) }
  
  enum Display: LocalizedError {
    case noConnection,
         registrationIDTaken,
         registrationInvalidID,
         modificationInvalidNewPIN,
         authenticationWrongPIN
    
    public init?(_ base: AuthenticationError) {
      switch base {
      case .noConnection:
        self = .noConnection
      case .registrationIDTaken:
        self = .registrationIDTaken
      case .registrationInvalidID:
        self = .registrationInvalidID
      case .modificationInvalidNewPIN:
        self = .modificationInvalidNewPIN
      case .authenticationWrongPIN:
        self = .authenticationWrongPIN
      default:
        return nil
      }
    }
    
    public var errorDescription: String? { String(localized: .init(key), bundle: .module) }
    public var key: String {
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
      }
    }
  }
}

