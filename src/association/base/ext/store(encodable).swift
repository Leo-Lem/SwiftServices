//	Created by Leopold Lemmermann on 10.11.22.

import Foundation

public extension KeyValueStorageService {
  func store<T: Encodable>(object: T, encoder: JSONEncoder = .init(), for key: Key, securely: Bool = false) throws {
    store(try encoder.encode(object), for: key, securely: securely)
  }
}
