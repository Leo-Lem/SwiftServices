//	Created by Leopold Lemmermann on 20.11.22.

/// The error thrown by the ``AuthenticationService``'s methods.
public enum AuthenticationError: Error {
  /// Can't connect to the authentication server.
  case noConnection
  /// Operation not permitted, because the user is not authenticated.
  case notAuthenticated

  // registration
  /// The ``Credential/ID`` user for registration exists already
  case registrationIDTaken(_ id: Credential.ID)
  /// The ``Credential/ID`` user for registration is invalid (unsupported characters, whitespace, etc.)
  case registrationInvalidID(_ id: Credential.ID)
  
  // authentication
  /// The ``Credential/ID`` used for authentication is not known.
  case authenticationUnknownID(_ id: Credential.ID)
  /// The ``Credential/PIN`` used for authentication does not match the one in the system
  case authenticationWrongPIN
  
  // others
  /// An unexpected status code was returned from the server.
  case unexpected(status: Int)
  /// Something else went wrong.
  case other(_ error: Error?)
}
