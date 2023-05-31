//	Created by Leopold Lemmermann on 01.12.22.

import Foundation

extension Credential {
  /// Attach a new ``Credential/PIN`` to the this credential.
  /// - Parameter newPIN: The new pin.
  /// - Returns: A ``Credential/WithNewPIN`` instance.
  func attachNewPIN(_ newPIN: Credential.PIN) -> Credential.WithNewPIN {
    Credential.WithNewPIN(credential: self, newPIN: newPIN)
  }

  /// A ``Credential`` with an attached new pin.
  struct WithNewPIN: Identifiable, Codable, Hashable {
    /// The base ``Credential``.
    public let credential: Credential
    /// The attached new pin.
    public let newPIN: Credential.PIN

    /// `Identiable` requirement.
    public var id: Credential.ID { credential.id }
  }
}

extension Credential {
  init(from data: Data) throws {
    do {
      self = try JSONDecoder().decode(Credential.self, from: data)
    } catch { throw AuthenticationError.other(error) }
  }
}
