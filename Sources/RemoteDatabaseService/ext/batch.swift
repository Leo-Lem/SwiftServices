//	Created by Leopold Lemmermann on 09.11.22.

import ExtendedConcurrency

public extension RemoteDatabaseService {
  // fetch
  func fetch<T: RemoteModelConvertible>(with ids: [T.ID]) async throws -> [T] {
    try await ids.compactMap(fetch)
  }
  
  func fetch<T: RemoteModelConvertible>(with ids: [T.ID]) -> AsyncThrowingStream<T, Error> {
    ids.compactMap(fetch)
  }
  
  @_disfavoredOverload
  func fetch<T: RemoteModelConvertible>(with ids: T.ID...) async throws -> [T] {
    try await fetch(with: ids)
  }
  
  @_disfavoredOverload
  func fetch<T: RemoteModelConvertible>(with ids: T.ID...) -> AsyncThrowingStream<T, Error> {
    fetch(with: ids)
  }
  
  // publish
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
  
  // unpublish
  
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
