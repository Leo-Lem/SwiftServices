//	Created by Leopold Lemmermann on 22.11.22.

import AuthenticationService

extension MyAuthenticationService {
  func loadCurrentCredential() throws -> Credential {
    guard
      case let .authenticated(id) = status,
      let pin: Credential.PIN = try? keyValueStorageService.load(objectFor: id, secure: true)
    else {
      throw AuthenticationError.notAuthenticated
    }
    
    return Credential(id: id, pin: pin)
  }
}
