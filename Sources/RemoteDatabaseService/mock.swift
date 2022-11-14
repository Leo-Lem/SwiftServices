//	Created by Leopold Lemmermann on 23.10.22.

import Combine
import Foundation
import Queries

open class MockRemoteDatabaseService: RemoteDatabaseService {
  public var status: RemoteDatabaseStatus = .readOnly
  
  public let didChange = PassthroughSubject<RemoteDatabaseChange, Never>()

  public init() {}
  
  public func publish<T: RemoteModelConvertible>(_ convertible: T) async throws -> T {
    print("Published \(convertible)!")
    return convertible
  }

  public func unpublish<T: RemoteModelConvertible>(with id: T.ID, _: T.Type = T.self) async throws {
    print("Deleted model with \(id)!")
  }

  public func fetch<T: RemoteModelConvertible>(_ query: Query<T>) -> AsyncThrowingStream<[T], Error> {
    print("Fetched \(query)!")
    return .init { return nil }
  }
  
  public func fetch<T: RemoteModelConvertible>(with id: T.ID) async throws -> T? {
    print("Fetched with \(id)!")
    return nil
  }
}
