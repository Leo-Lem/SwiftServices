//	Created by Leopold Lemmermann on 22.11.22.

import Foundation

extension UserDefaultsService {
  func storeSecure<T, Key: CustomStringConvertible>(
    _ item: T,
    for key: Key
  ) {
    let baseAttributes: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.description
    ]

    var attributes = baseAttributes
    attributes[kSecValueData] = item

    if SecItemAdd(attributes as CFDictionary, nil) == errSecDuplicateItem {
      let attributesToUpdate = [kSecValueData: item]

      SecItemUpdate(attributes as CFDictionary, attributesToUpdate as CFDictionary)
    }
  }

  func loadSecure<T, Key: CustomStringConvertible>(
    for key: Key
  ) -> T? {
    var result: AnyObject?
    SecItemCopyMatching([
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.description,
      kSecReturnData: true
    ] as CFDictionary, &result)

    return result as? T
  }

  func deleteSecure<Key: CustomStringConvertible>(
    for key: Key
  ) {
    SecItemDelete([
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.description
    ] as CFDictionary)
  }
}
