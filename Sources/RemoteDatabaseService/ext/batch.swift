//	Created by Leopold Lemmermann on 09.11.22.

public extension RemoteDatabaseService {
  @discardableResult
  func publish<T: RemoteModelConvertible>(_ convertibles: [T]) async throws -> [T] {
    for convertible in convertibles { try await publish(convertible) }
    return convertibles
  }
  
  @discardableResult
  func publish(_ convertibles: [any RemoteModelConvertible]) async throws -> [any RemoteModelConvertible] {
    for convertible in convertibles { try await publish(convertible) }
    return convertibles
  }
  
  @_disfavoredOverload
  @discardableResult
  func publish(_ convertibles: any RemoteModelConvertible...) async throws -> [any RemoteModelConvertible] {
    try await publish(convertibles)
  }
  
  @_disfavoredOverload
  @discardableResult
  func publish<T: RemoteModelConvertible>(_ convertibles: T...) async throws -> [T] {
    try await publish(convertibles)
  }
  
  func unpublish<T: RemoteModelConvertible>(_ convertibles: [T]) async throws {
    for convertible in convertibles { try await unpublish(convertible) }
  }
  
  func unpublish(_ convertibles: [any RemoteModelConvertible]) async throws {
    for convertible in convertibles { try await unpublish(convertible) }
  }
  
  @_disfavoredOverload
  func unpublish<T: RemoteModelConvertible>(_ convertibles: T...) async throws {
    try await unpublish(convertibles)
  }
  
  @_disfavoredOverload
  func unpublish(_ convertibles: any RemoteModelConvertible...) async throws {
    try await unpublish(convertibles)
  }
}
