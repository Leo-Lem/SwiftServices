//	Created by Leopold Lemmermann on 22.11.22.

import Foundation

extension UserDefaultsService {
  func store<T>(_ item: T, for key: Key) {
    local.set(item, forKey: key.description)
  }
  
  func storeSecurely<T>(_ item: T, for key: Key) {
    guard let data = item as? Data else { fatalError("You can only store raw Data securely.") }
    
    let baseAttributes: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
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
