//	Created by Leopold Lemmermann on 20.11.22.

/// The credential used for authentication..
public struct Credential: Identifiable, Codable, Hashable {
  /// The type of ID used in the ``Credential``.
  public typealias ID = String
  /// The type of PIN used in the ``Credential``.
  public typealias PIN = String

  /// The id of the credential.
  public var id: ID
  /// The pin of the credential
  public var pin: PIN
  
  /// Initialize a ``Credential`` with the given ``Credential/ID`` and ``Credential/PIN``.
  /// - Parameters:
  ///   - id: The id of the credential.
  ///   - pin: The pin of the credential
  public init(id: ID, pin: PIN) {
    self.id = id
    self.pin = pin
  }
}
