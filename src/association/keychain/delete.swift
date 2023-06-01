// Created by Leopold Lemmermann on 01.06.23.

import Foundation

public extension KeychainService {
  func delete(for key: any CustomStringConvertible) {
    SecItemDelete([
      kSecClass: valueClass.kSecClass,
      kSecAttrAccount: key.description
    ] as [CFString: Any] as CFDictionary)
  }
}
