//	Created by Leopold Lemmermann on 23.10.22.

@available(iOS 16, macOS 13, *)
public extension DatabaseService where Self == MockDatabaseService {
  static var mock: MockDatabaseService { MockDatabaseService() }
}

@available(iOS 16, macOS 13, *)
open class MockDatabaseService: DatabaseService {
  public let didChange = DidChangePublisher()
  public var status: DatabaseStatus = .readOnly

  var store = [String: any DatabaseObjectConvertible]()

  public init() {}

  public func insert<T: DatabaseObjectConvertible>(_ convertible: T) async throws -> T {
    store[convertible.id.description] = convertible
    didChange.send(.inserted(convertible))

    print("Inserted \(convertible)!")
    return convertible
  }

  public func delete<T: DatabaseObjectConvertible>(_: T.Type, with id: T.ID) async throws {
    store.removeValue(forKey: id.description)
    didChange.send(.deleted(T.self, id: id))

    print("Deleted database object with \(id)!")
  }

  public func fetch<T: DatabaseObjectConvertible>(with id: T.ID) async throws -> T? {
    print("Fetched convertible (id: \(id)).")
    return store[id.description] as? T
  }
  
  public func fetch<T: DatabaseObjectConvertible>(_ query: Query<T>) -> AsyncThrowingStream<[T], Error> {
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
      print("Fetched \(query) from database.")
      return !bool ?
        .init {_ in} :
        .init { continuation in
        while !result.isEmpty {
          continuation.yield(Array(result.prefix(batchSize)))
          result.removeFirst(min(result.count, batchSize))
        }

        continuation.finish()
      }
    default:
      print("WARNING: Predicate queries cannot be evaluated in the mock; returning all \(T.self).")
      return .init { continuation in
        while !result.isEmpty {
          continuation.yield(Array(result.prefix(batchSize)))
          result.removeFirst(batchSize)
        }

        continuation.finish()
      }
    }
  }
}
