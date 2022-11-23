//	Created by Leopold Lemmermann on 09.11.22.

import CloudKit
import RemoteDatabaseService

extension CloudKitService {
  func mapToRemoteDatabaseError<T>(_ action: () throws -> T) rethrows -> T {
    do {
      return try action()
    } catch let error as CKError {
      throw RemoteDatabaseError(ckError: error) ?? error
    } catch let error as RemoteDatabaseError {
      throw error
    } catch {
      throw RemoteDatabaseError.other(error)
    }
  }

  func mapToRemoteDatabaseError<T>(_ action: () async throws -> T) async rethrows -> T {
    do {
      return try await action()
    } catch let error as CKError {
      throw RemoteDatabaseError(ckError: error) ?? error
    } catch let error as RemoteDatabaseError {
      throw error
    } catch {
      throw RemoteDatabaseError.other(error)
    }
  }
  
  func mapToRemoteDatabaseError(_ error: Error) -> Error {
    do {
      try mapToRemoteDatabaseError { throw error }
      return error
    } catch { return error }
  }
}

extension RemoteDatabaseError {
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
