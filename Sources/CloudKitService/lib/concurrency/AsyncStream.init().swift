//	Created by Leopold Lemmermann on 10.11.22.

public extension AsyncStream {
  init(
    _ elementType: Element.Type = Element.self,
    bufferingPolicy: Continuation.BufferingPolicy = .unbounded,
    build: @escaping (Continuation) async -> Void
  ) {
    self.init(elementType, bufferingPolicy: bufferingPolicy) { continuation in
      Task { await build(continuation) }
    }
  }
}

public extension AsyncThrowingStream {
  init(
    _ elementType: Element.Type = Element.self,
    bufferingPolicy: Continuation.BufferingPolicy = .unbounded,
    build: @escaping (Continuation) async -> Void
  ) where Failure == any Error {
    self.init(elementType, bufferingPolicy: bufferingPolicy) { continuation in
      Task { await build(continuation) }
    }
  }
}

