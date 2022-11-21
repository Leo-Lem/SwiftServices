//	Created by Leopold Lemmermann on 21.10.22.

public enum AuthenticationStatus {
  case notAuthenticated,
       authenticated(_ credential: Credential)
}
