//	Created by Leopold Lemmermann on 21.10.22.

import class Combine.PassthroughSubject
import Concurrency

/// The `Publisher` used to publish changes in an ``AuthenticationStatus``.
public typealias AuthenticationEventPublisher = PassthroughSubject<AuthenticationStatus, Never>

@available(iOS 15, macOS 12, *)
public extension AuthenticationService {
  var events: AsyncStream<AuthenticationStatus> { eventPublisher.stream }
}

/// The current status of authentication.
public enum AuthenticationStatus: Equatable {
  /// Can't connect to the server.
  case noConnection
  /// Not authenticated.
  case notAuthenticated
  /// Authenticated (with the associated ID).
  case authenticated(_ id: Credential.ID)
}
