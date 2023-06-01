// Created by Leopold Lemmermann on 01.06.23.

import Foundation

public extension KeychainService {
  /// A Swift wrapper for KeychainServices' `kSecClasses`.
  enum ValueClass {
    case genericPassword
    case internetPassword
    case certificate
    case key
    case identity
  }
}

public extension KeychainService.ValueClass {
  /// The corresponding `kSecClass` `CFString`.
  var kSecClass: CFString {
    switch self {
    case .genericPassword: return kSecClassGenericPassword
    case .internetPassword: return kSecClassInternetPassword
    case .certificate: return kSecClassCertificate
    case .key: return kSecClassKey
    case .identity: return kSecClassIdentity
    }
  }
}
