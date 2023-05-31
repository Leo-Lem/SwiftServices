//	Created by Leopold Lemmermann on 01.12.22.

extension MyAuthenticationService {
  func performLogin(_ credential: Credential) -> Credential.ID {
    save(credential: credential)
    status = .authenticated(credential.id)
    return credential.id
  }
  
  func performLogout(_ id: Credential.ID) {
    deleteCredential(with: id)
    status = .notAuthenticated
  }
}
