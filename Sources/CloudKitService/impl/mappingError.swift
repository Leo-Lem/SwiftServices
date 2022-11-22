//	Created by Leopold Lemmermann on 09.11.22.

import CloudKit
import RemoteDatabaseService

extension CloudKitService {
  func mapToCloudKitError<T>(_ action: () throws -> T) rethrows -> T {
    do {
      return try action()
    } catch let error as CKError {
      throw RemoteDatabaseError.UserRelevantError(ckError: error) ?? error
    } catch let error as RemoteDatabaseError {
      throw error
    } catch {
      throw RemoteDatabaseError.other(error)
    }
  }

  func mapToCloudKitError<T>(_ action: () async throws -> T) async rethrows -> T {
    do {
      return try await action()
    } catch let error as CKError {
      throw RemoteDatabaseError.UserRelevantError(ckError: error) ?? error
    } catch let error as RemoteDatabaseError {
      throw error
    } catch {
      throw RemoteDatabaseError.other(error)
    }
  }
  
  func mapToCloudKitError(_ error: Error) -> Error {
    do {
      try mapToCloudKitError { throw error }
      return error
    } catch { return error }
  }
}
