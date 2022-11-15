//	Created by Leopold Lemmermann on 10.11.22.

import Foundation

public extension KeyValueStorageService {
  func store<T: Encodable>(
    object: T,
    encoder: JSONEncoder = .init(),
    for key: String
  ) throws {
    store(try encoder.encode(object), for: key)
  }

  func fetchObject<T: Decodable>(
    decoder: JSONDecoder = .init(),
    for key: String
  ) throws -> T? {
    try (load(for: key) as Data?)
      .flatMap { data in
        try decoder.decode(T.self, from: data)
      }
  }
}
