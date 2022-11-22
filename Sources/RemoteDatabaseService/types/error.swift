//	Created by Leopold Lemmermann on 31.10.22.

import CloudKit

public enum RemoteDatabaseError: Error {
  case mapping(invalidRemoteModel: Any.Type),
       notAuthenticated,
       noNetwork,
       rateLimited,
       other(Error)

  public init?(ckError: CKError) {
    switch ckError.code {
    case .networkFailure, .networkUnavailable, .serverResponseLost, .serviceUnavailable:
      self = .noNetwork
    case .notAuthenticated:
      self = .notAuthenticated
    case .requestRateLimited:
      self = .rateLimited
    default: return nil
    }
  }
}
