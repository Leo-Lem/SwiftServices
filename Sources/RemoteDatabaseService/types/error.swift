//	Created by Leopold Lemmermann on 31.10.22.

import CloudKit

public enum RemoteDatabaseError: Error {
  case mapping(invalidRemoteModel: Any.Type),
       notAuthenticated,
       noNetwork,
       rateLimited,
       other(Error)
}
