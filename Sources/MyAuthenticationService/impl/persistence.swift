//	Created by Leopold Lemmermann on 22.11.22.

import Errors
import UserDefaultsService

extension MyAuthenticationService {
  func save(credential: Credential) {
    try? keyValueStorageService.store(object: credential.pin, for: credential.id, secure: true)
    try? keyValueStorageService.store(object: credential.id, for: Self.userIDKey)
  }

  func loadCredential() -> Credential? {
    guard let id = loadID(), let pin = loadPIN(for: id) else { return nil }

    return Credential(id: id, pin: pin)
  }

  func loadCurrentCredential() throws -> Credential {
    guard case let .authenticated(id) = status, let pin = loadPIN(for: id) else {
      throw AuthenticationError.notAuthenticated
    }

    return Credential(id: id, pin: pin)
  }

  func deleteCredential(with id: Credential.ID) {
    keyValueStorageService.delete(for: id, secure: true)
    keyValueStorageService.delete(for: Self.userIDKey)
  }
}

private extension MyAuthenticationService {
  static let userIDKey = "current-user-id"

  func loadID() -> Credential.ID? {
    printError {
      try keyValueStorageService.load(objectFor: Self.userIDKey)
    }
  }

  func loadPIN(for id: Credential.ID) -> Credential.PIN? {
    printError {
      try keyValueStorageService.load(objectFor: id, secure: true)
    }
  }
}
