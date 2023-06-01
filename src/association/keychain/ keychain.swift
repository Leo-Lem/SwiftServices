// Created by Leopold Lemmermann on 01.06.23.

/// A wrapper around Apple's KeychainServices implementing the ``AssociationService`` protocol.
open class KeychainService: AssociationService {
  public var valueClass: ValueClass

  public init(valueClass: ValueClass) { self.valueClass = valueClass }
}
