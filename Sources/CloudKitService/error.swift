//	Created by Leopold Lemmermann on 31.10.22.

import CloudKit
import RemoteDatabaseService

public enum CloudKitError: Error {
  case mapping(invalidRemoteModel: Any.Type),
       fetching(UserRelevantError, type: any RemoteModelConvertible),
       publishing(UserRelevantError, type: any RemoteModelConvertible),
       unpublishing(UserRelevantError, type: any RemoteModelConvertible),
       other(Error)
  
  public enum UserRelevantError: Error {
    case notAuthenticated,
         noNetwork,
         rateLimited
    
    init?(ckError: CKError) {
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
}
