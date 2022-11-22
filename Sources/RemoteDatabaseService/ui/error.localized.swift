//	Created by Leopold Lemmermann on 27.10.22.

import SwiftUI

@available(iOS 15, macOS 13, *)
extension RemoteDatabaseError.UserRelevantError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .noNetwork:
      return "CLOUDKITERROR_CONNECTION"
    case .notAuthenticated:
      return "CLOUDKITERROR_AUTH"
    case .rateLimited:
      return "CLOUDKITERROR_RATE"
    }
  }
}
