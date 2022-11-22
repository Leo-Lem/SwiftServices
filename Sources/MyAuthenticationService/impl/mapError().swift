//	Created by Leopold Lemmermann on 22.11.22.

import AuthenticationService

extension MyAuthenticationService {
  func mapError<T>(_ throwing: () async throws -> T) async rethrows -> T {
    do {
      return try await throwing()
    } catch let error as AuthenticationError {
      throw error
    } catch {
      throw AuthenticationError.other(error)
    }
  }
}
