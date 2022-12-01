//	Created by Leopold Lemmermann on 21.10.22.

import class Combine.PassthroughSubject
/// The `Publisher` used to publish changes in an ``AuthenticationStatus``.
public typealias StatusChangePublisher = PassthroughSubject<AuthenticationStatus, Never>

/// The current status of authentication.
public enum AuthenticationStatus: Equatable {
  /// Can't connect to the server.
  case noConnection
  /// Not authenticated.
  case notAuthenticated
  /// Authenticated (with the associated ID).
  case authenticated(_ id: Credential.ID)
}
