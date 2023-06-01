// Created by Leopold Lemmermann on 01.06.23.

@_exported import protocol AssociationService.AssociationService
import Foundation

open class KeychainService: AssociationService {
  public private(set) var valueClass: CFString

  public init(valueClass: CFString) {
    self.valueClass = valueClass
  }
}
