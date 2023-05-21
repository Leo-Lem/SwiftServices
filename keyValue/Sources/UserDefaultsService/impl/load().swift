//	Created by Leopold Lemmermann on 03.12.22.

import Foundation

extension UserDefaultsService {
  func load<T>(for key: Key) -> T? {
    return local.object(forKey: key.description) as? T
  }
  
  func loadSecurely<T>(for key: Key) -> T? {
    var result: AnyObject?
    
    SecItemCopyMatching([
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.description,
      kSecReturnData: true
    ] as CFDictionary, &result)

    return result as? T
  }
}
