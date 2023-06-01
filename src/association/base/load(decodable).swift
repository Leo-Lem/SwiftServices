//	Created by Leopold Lemmermann on 03.12.22.

import class Foundation.JSONDecoder

public extension AssociationService {
  /// Load a decodable item.
  /// - Parameters:
  ///   - key: A `CustomStringConvertible` to be associated the with stored item.
  ///   - decoder: A `JSONDecoder` to handle decoding. (default: `JSONDecoder()`)
  /// - Returns: The decoded item.
  func load<T: Decodable>(objectFor key: any CustomStringConvertible, decoder: JSONDecoder = .init()) throws -> T? {
    try load(for: key).flatMap { try decoder.decode(T.self, from: $0) }
  }
}
