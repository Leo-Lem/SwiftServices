//	Created by Leopold Lemmermann on 22.11.22.

import AuthenticationService
import UserDefaultsService

extension MyAuthenticationService {
  static let userIDKey = "current-user-id"

  func saveCredential(_ credential: Credential) {
    keyValueStorageService.store(credential.pin, for: credential.id, secure: true)
    keyValueStorageService.store(credential.id, for: Self.userIDKey)
  }

  func loadCredential() -> Credential? {
    if
      let id: String = keyValueStorageService.load(for: Self.userIDKey),
      let pin: String = keyValueStorageService.load(for: id, secure: true)
    {
      return Credential(id: id, pin: pin)
    } else {
      return nil
    }
  }

  func deleteCredential(userID: String) {
    keyValueStorageService.delete(for: userID, secure: true)
    keyValueStorageService.delete(for: Self.userIDKey)
  }
}
