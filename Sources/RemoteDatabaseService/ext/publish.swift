//	Created by Leopold Lemmermann on 09.11.22.

import Concurrency

public extension RemoteDatabaseService {
  @_disfavoredOverload
  @discardableResult
  func publish<T: RemoteModelConvertible>(_ convertibles: T...) -> AsyncThrowingStream<T, Error> {
    publish(convertibles)
  }

  @discardableResult
  func publish<T: RemoteModelConvertible>(_ convertibles: [T]) -> AsyncThrowingStream<T, Error> {
    AsyncThrowingStream { continuation in
      do {
        for convertible in convertibles {
          try await publish(convertible)
          continuation.yield(convertible)
        }

        continuation.finish()
      } catch { continuation.finish(throwing: error) }
    }
  }

  @_disfavoredOverload
  @discardableResult
  func publish(
    _ convertibles: any RemoteModelConvertible...
  ) -> AsyncThrowingStream<any RemoteModelConvertible, Error> {
    publish(convertibles)
  }

  @discardableResult
  func publish(_ convertibles: [any RemoteModelConvertible]) -> AsyncThrowingStream<any RemoteModelConvertible, Error> {
    AsyncThrowingStream { continuation in
      do {
        for convertible in convertibles {
          try await publish(convertible)
          continuation.yield(convertible)
        }

        continuation.finish()
      } catch { continuation.finish(throwing: error) }
    }
  }
}
