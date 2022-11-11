//	Created by Leopold Lemmermann on 21.10.22.

import Combine
import Queries

public protocol RemoteDatabaseService {
  var status: RemoteDatabaseStatus { get }

  var didChange: PassthroughSubject<RemoteDatabaseChange, Never> { get }

  @discardableResult
  func publish<T: RemoteModelConvertible>(_ convertible: T) async throws -> T

  func unpublish<T: RemoteModelConvertible>(with id: T.ID, _: T.Type) async throws

  func fetch<T: RemoteModelConvertible>(with id: T.ID) async throws -> T?
  func fetch<T: RemoteModelConvertible>(_ query: Query<T>) -> AsyncThrowingStream<T, Error>
}
