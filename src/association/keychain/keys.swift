// Created by Leopold Lemmermann on 01.06.23.

import Foundation

public extension KeychainService {
  var keys: [String] {
    var result: AnyObject?

    SecItemCopyMatching([
      kSecClass: valueClass,
      kSecMatchLimit: kSecMatchLimitAll,
      kSecReturnData: true
    ] as [CFString: Any] as CFDictionary, &result)

    return result as? [String] ?? []
  }
}
