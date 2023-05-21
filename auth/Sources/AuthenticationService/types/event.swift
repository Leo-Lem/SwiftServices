// Created by Leopold Lemmermann on 13.12.22.

public enum AuthenticationEvent {
  /// A new user was registered.
  case registered
  /// The user was logged in.
  case loggedIn
  /// The user was logged out.
  case loggedOut
  /// The user changed their PIN.
  case changedPin
  /// The user deleted their account.
  case deregistered
}
