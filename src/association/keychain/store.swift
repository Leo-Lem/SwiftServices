// Created by Leopold Lemmermann on 01.06.23.

import Foundation

public extension KeychainService {
  func store<T>(_ item: T, for key: any CustomStringConvertible) {
    guard let data = item as? Data else { fatalError("You can only store raw Data securely.") }

    let baseAttributes: [CFString: Any] = [
      kSecClass: valueClass.kSecClass,
      kSecAttrAccount: key.description
    ]

    var attributes = baseAttributes
    attributes[kSecValueData] = data

    print(SecItemAdd(attributes as CFDictionary, nil))

    if SecItemAdd(attributes as CFDictionary, nil) == errSecDuplicateItem {
      let attributesToUpdate = [kSecValueData: data]

      SecItemUpdate(attributes as CFDictionary, attributesToUpdate as CFDictionary)
    }
  }
}
