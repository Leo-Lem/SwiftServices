//	Created by Leopold Lemmermann on 10.11.22.

import Foundation

public extension KeyValueStorageService {
  func insert<T: Encodable>(
    object: T,
    encoder: JSONEncoder = .init(),
    for key: String
  ) throws {
    try insert(try encoder.encode(object), for: key)
  }

  func fetchObject<T: Decodable>(
    decoder: JSONDecoder = .init(),
    for key: String
  ) throws -> T? {
    if let data: Data = try load(for: key) {
      return try decoder.decode(T.self, from: data)
    } else { return nil }
  }
}
