//	Created by Leopold Lemmermann on 09.11.22.

import Concurrency

public extension DatabaseService {
  /// Batch insert convertibles into the database.
  /// - Parameter convertibles: The ``DatabaseObjectConvertible``s to be inserted.
  ///  - Throws: A ``DatabaseError``.
  @discardableResult
  func insert<T: DatabaseObjectConvertible>(_ convertibles: [T]) -> AsyncThrowingStream<T, Error> {
    AsyncThrowingStream { continuation in
      do {
        for convertible in convertibles {
          try await self.insert(convertible)
          continuation.yield(convertible)
        }

        continuation.finish()
      } catch { continuation.finish(throwing: error) }
    }
  }
  
  /// Heterogenous batch insert convertibles into the database.
  /// - Parameter convertibles: The ``DatabaseObjectConvertible``s to be inserted.
  ///  - Throws: A ``DatabaseError``.
  @discardableResult
  func insert(_ convertibles: [any DatabaseObjectConvertible])
    -> AsyncThrowingStream<any DatabaseObjectConvertible, Error>
  {
    AsyncThrowingStream { continuation in
      do {
        for convertible in convertibles {
          try await self.insert(convertible)
          continuation.yield(convertible)
        }

        continuation.finish()
      } catch { continuation.finish(throwing: error) }
    }
  }
}
