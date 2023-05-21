//	Created by Leopold Lemmermann on 03.12.22.

import Foundation

public extension KeyValueStorageService {
  func load<T: Decodable>(decoder: JSONDecoder = .init(), objectFor key: Key, securely: Bool = false) throws -> T? {
    try load(for: key, securely: securely)
      .flatMap { try decoder.decode(T.self, from: $0) }
  }
}
