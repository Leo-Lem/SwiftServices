import Concurrency

public protocol AuthenticationService: EventDriver where Event == AuthenticationStatus {
  /// The current ``AutenticationStatus``.
  var status: AuthenticationStatus { get }
  
  /// Check, whether the given ``Credential/ID`` is found in the server.
  /// - Parameter id: The ``Credential/ID`` to check.
  /// - Returns: A `Bool` indicating existence.
  /// - Throws: An ``AuthenticationError``.
  func exists(_ id: Credential.ID) async throws -> Bool
  
  /// Register the provided credential.
  /// - Parameter credential: The ``Credential`` to register with.
  /// - Returns: When successful, the ``Credential/ID``.
  /// - Throws: An ``AuthenticationError``.
  @discardableResult func register(_ credential: Credential) async throws -> Credential.ID
  
  /// Login with the provided credential.
  /// - Parameter credential: The ``Credential`` to authenticate with.
  /// - Returns: When successful, the ``Credential/ID``.
  /// - Throws: An ``AuthenticationError``.
  @discardableResult func login(_ credential: Credential) async throws -> Credential.ID
  
  /// Change the ``Credential/PIN`` associated with the current logged in user.
  /// - Parameter newPIN: The new ``Credential/PIN``.
  /// - Returns: When successful, the ``Credential/ID``.
  /// - Throws: An ``AuthenticationError``.
  @discardableResult func changePIN(_ newPIN: Credential.PIN) async throws -> Credential.ID
  
  /// Delete the currently logged in user from the server.
  /// - Throws: An ``AuthenticationError``.
  func deregister() async throws
  
  /// Log the current user out.
  /// - Throws: An ``AuthenticationError``.
  func logout() throws
}
