//  Created by Leopold Lemmermann on 20.10.22.

public protocol IndexingService {
  func updateReference<T: Indexable>(to indexable: T) async throws
  func removeReference(with id: String) async throws
}
