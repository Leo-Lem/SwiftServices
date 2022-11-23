//	Created by Leopold Lemmermann on 23.10.22.

import Combine
import Foundation
import Queries
import Concurrency

open class MockRemoteDatabaseService: RemoteDatabaseService {
  public var status: RemoteDatabaseStatus = .readOnly
  
  public let didChange = PassthroughSubject<RemoteDatabaseChange, Never>()

  var store = [String: any RemoteModelConvertible]()
  
  public init() {}
  
  public func publish<T: RemoteModelConvertible>(_ convertible: T) async throws -> T {
    store[convertible.id.description] = convertible
    didChange.send(.published(convertible))
    await sleep(for: .seconds(0.1))
    
    print("Published \(convertible)!")
    return convertible
  }

  public func unpublish<T: RemoteModelConvertible>(with id: T.ID, _: T.Type = T.self) async throws {
    store.removeValue(forKey: id.description)
    didChange.send(.unpublished(id: id, type: T.self))
    await sleep(for: .seconds(0.1))
    
    print("Deleted model with \(id)!")
  }

  public func fetch<T: RemoteModelConvertible>(_ query: Query<T>) -> AsyncThrowingStream<[T], Error> {
    let values = store.values.compactMap { $0 as? T }
    
    var result: [T]
    if let max = query.options.maxItems {
      result = Array(values.prefix(max))
    } else {
      result = values
    }
    
    let batchSize = query.options.batchSize
    
    switch query.predicateType {
    case let .bool(bool):
      print("Fetched \(query) from local database.")
      return !bool ?
        .init {_ in} :
        .init { continuation in
        while !result.isEmpty {
          continuation.yield(Array(result.prefix(batchSize)))
          result.removeFirst(batchSize)
          await sleep(for: .seconds(0.1))
        }
        
        continuation.finish()
      }
    default:
      print("WARNING: Predicate queries cannot be evaluated in the mock; returning all \(T.self).")
      return .init { continuation in
        while !result.isEmpty {
          continuation.yield(Array(result.prefix(batchSize)))
          result.removeFirst(batchSize)
          await sleep(for: .seconds(0.1))
        }
        
        continuation.finish()
      }
    }
  }
  
  public func fetch<T: RemoteModelConvertible>(with id: T.ID) async throws -> T? {
    await sleep(for: .seconds(0.1))
    print("Fetched convertible (id: \(id)) from remote database.")
    return store[id.description] as? T
  }
}
