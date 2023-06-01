//	Created by Leopold Lemmermann on 10.11.22.

import class Foundation.JSONEncoder

public extension AssociationService {
  func store<T: Encodable>(object: T, for key: any LosslessStringConvertible, encoder: JSONEncoder = .init()) throws {
    store(try encoder.encode(object), for: key)
  }
}
