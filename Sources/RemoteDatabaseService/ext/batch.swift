//	Created by Leopold Lemmermann on 09.11.22.

public extension RemoteDatabaseService {
  @discardableResult
  func publish(_ convertibles: [any RemoteModelConvertible]) async throws -> [any RemoteModelConvertible] {
    for convertible in convertibles { try await publish(convertible) }
    return convertibles
  }
  
  @discardableResult
  func unpublish(_ convertibles: [any RemoteModelConvertible]) async throws -> [any RemoteModelConvertible] {
    for convertible in convertibles { try await unpublish(convertible) }
    return convertibles
  }
  
  @_disfavoredOverload
  @discardableResult
  func unpublish(_ convertibles: any RemoteModelConvertible...) async throws -> [any RemoteModelConvertible] {
    try await unpublish(convertibles)
  }
  
  @_disfavoredOverload
  @discardableResult
  func publish(_ convertibles: any RemoteModelConvertible...) async throws -> [any RemoteModelConvertible] {
    try await publish(convertibles)
  }
}
