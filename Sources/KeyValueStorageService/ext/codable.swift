//	Created by Leopold Lemmermann on 10.11.22.

import Foundation

public extension KeyValueStorageService {
  func store<T: Encodable>(
    object: T,
    encoder: JSONEncoder = .init(),
    for key: String,
    secure: Bool = false
  ) throws {
    store(try encoder.encode(object), for: key, secure: secure)
  }

  func load<T: Decodable>(
    decoder: JSONDecoder = .init(),
    objectFor key: String,
    secure: Bool = false
  ) throws -> T? {
    try (load(for: key, secure: secure) as Data?)
      .flatMap { data in
        try decoder.decode(T.self, from: data)
      }
  }
}
