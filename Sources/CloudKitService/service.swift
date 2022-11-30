//	Created by Leopold Lemmermann on 23.10.22.

@_exported import CloudKit
@_exported import DatabaseService
import Concurrency

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
open class CloudKitService: DatabaseService {
  public typealias Convertible = DatabaseObjectConvertible

  public internal(set) var status: DatabaseStatus = .unavailable
  public let didChange = DidChangePublisher()

  let container: CloudKitContainer
  private let scope: CloudKitDatabaseScope
  var database: CloudKitDatabase { container.database(with: scope) }

  private let tasks = Tasks()

  public init(container: CloudKitContainer, scope: CloudKitDatabaseScope = .public) async {
    self.container = container
    self.scope = scope

    tasks.add(updateStatusOnChange(), updatePeriodically(every: 60))

    status = await getStatus()
  }

  @discardableResult
  public func insert<T: Convertible>(_ convertible: T) async throws -> T {
    guard status != .readOnly else { throw DatabaseError.databaseIsReadOnly }
    guard status != .unavailable else { throw DatabaseError.databaseIsUnavailable }

    return try await mapToDatabaseError {
      try await database.save(CKRecord.castFrom(databaseObject: try await mapToDatabaseObject(convertible)))
      didChange.send(.inserted(convertible))
      return convertible
    }
  }

  public func delete<T: Convertible>(_: T.Type, with id: T.ID) async throws {
    guard status != .readOnly else { throw DatabaseError.databaseIsReadOnly }
    guard status != .unavailable else { throw DatabaseError.databaseIsUnavailable }

    return try await mapToDatabaseError {
      try await database.deleteRecord(withID: CKRecord.ID(recordName: id.description))
      didChange.send(.deleted(T.self, id: id))
    }
  }

  public func fetch<T: Convertible>(with id: T.ID) async throws -> T? {
    guard status != .unavailable else { throw DatabaseError.databaseIsUnavailable }

    return try await mapToDatabaseError {
      try await fetchDatabaseObject(T.self, with: id).flatMap(T.init)
    }
  }

  public func fetch<T: Convertible>(_ query: Query<T>) -> AsyncThrowingStream<[T], Error> {
    fetchDatabaseObjects(query)
      .map { $0.map(T.init) }
      .mapError(mapToDatabaseError)
  }
}
