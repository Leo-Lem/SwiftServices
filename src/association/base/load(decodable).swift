//	Created by Leopold Lemmermann on 03.12.22.

import class Foundation.JSONDecoder

public extension AssociationService {
  func load<T: Decodable>(objectFor key: any LosslessStringConvertible, decoder: JSONDecoder = .init()) throws -> T? {
    try load(for: key).flatMap { try decoder.decode(T.self, from: $0) }
  }
}
