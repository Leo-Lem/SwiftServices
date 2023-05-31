//	Created by Leopold Lemmermann on 03.12.22.

import Foundation

extension UserDefaultsService {
  func delete(for key: Key) {
    local.removeObject(forKey: key.description)
  }
  
  func deleteSecurely(for key: Key) {
    SecItemDelete([
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.description
    ] as [CFString : Any] as CFDictionary)
  }
}
