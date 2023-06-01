//	Created by Leopold Lemmermann on 10.11.22.

import class Foundation.JSONEncoder

public extension AssociationService {
  /// Store an encodable item.
  /// - Parameters:
  ///   - object: The encodable item to be stored.
  ///   - key: A '`CustomStringConvertible` to be associated with the stored item.
  ///   - encoder: A `JSONEncoder` to handle encoding. (default: `JSONEncoder()`)
  func store<T: Encodable>(object: T, for key: any CustomStringConvertible, encoder: JSONEncoder = .init()) throws {
    store(try encoder.encode(object), for: key)
  }
}
