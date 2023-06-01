// Created by Leopold Lemmermann on 01.06.23.

@_exported import protocol AssociationService.AssociationService

open class KeychainService: AssociationService {
  public var valueClass: ValueClass

  public init(valueClass: ValueClass) { self.valueClass = valueClass }
}
