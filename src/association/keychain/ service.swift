// Created by Leopold Lemmermann on 01.06.23.

@_exported import protocol AssociationService.AssociationService

open class KeychainService: AssociationService {
  public var valueClass: ValueClass

  /// Initialize a new `KeychainService`.
  /// - Parameter valueClass: The ``ValueClass-swift.enum`` to use for storing items.
  public init(valueClass: ValueClass) { self.valueClass = valueClass }
}
