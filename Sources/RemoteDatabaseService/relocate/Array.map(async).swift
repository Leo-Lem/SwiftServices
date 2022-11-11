//	Created by Leopold Lemmermann on 11.11.22.

extension Array {
  func map<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
    var values = [T]()
    for element in self {
      values.append(try await transform(element))
    }
    return values
  }

  func compactMap<T>(_ transform: (Element) async throws -> T?) async rethrows -> [T] {
    var values = [T]()
    for element in self {
      if let newElement = try await transform(element) { values.append(newElement) }
    }
    return values
  }

  func map<T>(_ transform: @escaping (Element) async -> T) -> AsyncStream<T> {
    AsyncStream { continuation in
      for element in self {
        continuation.yield(await transform(element))
      }

      continuation.finish()
    }
  }

  func compactMap<T>(_ transform: @escaping (Element) async -> T?) -> AsyncStream<T> {
    AsyncStream { continuation in
      for element in self {
        if let newElement = await transform(element) { continuation.yield(newElement) }
      }

      continuation.finish()
    }
  }

  func map<T>(_ transform: @escaping (Element) async throws -> T) -> AsyncThrowingStream<T, Error> {
    AsyncThrowingStream { continuation in
      do {
        for element in self {
          continuation.yield(try await transform(element))
        }

        continuation.finish()
      } catch {
        continuation.finish(throwing: error)
      }
    }
  }

  func compactMap<T>(_ transform: @escaping (Element) async throws -> T?) -> AsyncThrowingStream<T, Error> {
    AsyncThrowingStream { continuation in
      do {
        for element in self {
          if let newElement = try await transform(element) { continuation.yield(newElement) }
        }

        continuation.finish()
      } catch {
        continuation.finish(throwing: error)
      }
    }
  }
}
