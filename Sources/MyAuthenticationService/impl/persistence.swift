//	Created by Leopold Lemmermann on 22.11.22.

import AuthenticationService
import UserDefaultsService

extension MyAuthenticationService {
  static let userIDKey = "current-user-id"

  func saveCredential(_ credential: Credential) {
    try? keyValueStorageService.store(object: credential.pin, for: credential.id, secure: true)
    try? keyValueStorageService.store(object: credential.id, for: Self.userIDKey)
  }

  func loadCredential() -> Credential? {
    if
      let id: String = try? keyValueStorageService.load(objectFor: Self.userIDKey),
      let pin: String = try? keyValueStorageService.load(objectFor: id, secure: true)
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
