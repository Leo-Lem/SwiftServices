//	Created by Leopold Lemmermann on 21.10.22.

/// The current status of authentication.
public enum AuthenticationStatus: Equatable {
  /// Can't connect to the server.
  case noConnection
  /// Not authenticated.
  case notAuthenticated
  /// Authenticated (with the associated ID).
  case authenticated(_ id: Credential.ID)
}
