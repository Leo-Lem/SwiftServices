// Created by Leopold Lemmermann on 01.06.23.

import Foundation

public extension KeychainService {
  func load<T>(for key: any LosslessStringConvertible) -> T? {
    var result: AnyObject?

    SecItemCopyMatching([
      kSecClass: valueClass,
      kSecAttrAccount: key.description,
      kSecReturnData: true
    ] as [CFString: Any] as CFDictionary, &result)

    return result as? T
  }
}
