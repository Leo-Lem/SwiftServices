//	Created by Leopold Lemmermann on 09.11.22.

import Errors

extension CloudKitService {
  func mapToDatabaseError<T>(_ action: () async throws -> T) async rethrows -> T {
    do {
      return try await action()
    } catch {
      throw mapToDatabaseError(error)
    }
  }

  func mapToDatabaseError(_ error: Error) -> Error {
    switch error {
    case let error as CKError:
      switch error.code {
      case .networkFailure, .networkUnavailable, .serverResponseLost, .serviceUnavailable:
        return DatabaseError.status(.unavailable)
      case .notAuthenticated:
        return DatabaseError.status(.readOnly)
      default:
        return DatabaseError.other(error)
      }
    case is DatabaseError: return error
    default: return DatabaseError.other(error)
    }
  }
}
