//  Created by Leopold Lemmermann on 10.11.22.

extension AsyncSequence {
  /// Asynchronously waits for the `AsyncSequence`'s completion and then returns all values.
  /// - throws: The `AsyncSequence`'s error type.
  /// - returns: An `Array` of the `AsyncSequence`'s elements.
  func collect() async throws -> [Element] {
    var values = [Element]()
    for try await value in self {
      values.append(value)
    }
    return values
  }
}
