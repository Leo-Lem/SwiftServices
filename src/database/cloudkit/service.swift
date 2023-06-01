//	Created by Leopold Lemmermann on 23.10.22.

@_exported import CloudKit
@_exported import DatabaseService
import Concurrency

open class CloudKitService: DatabaseService {
  public typealias Convertible = DatabaseObjectConvertible

  public internal(set) var status: DatabaseStatus = .unavailable

  let container: CloudKitContainer
  private let scope: CloudKitDatabaseScope
  var database: CloudKitDatabase { container.database(with: scope) }

  private let tasks = Tasks()

  public init(container: CloudKitContainer, scope: CloudKitDatabaseScope = .public) {
    self.container = container
    self.scope = scope

    tasks["updateStatusOnChange"] = Task(priority: .high) { await updateStatusOnChange() }
    tasks["updatePeriodically"] = Task(priority: .background) { await updatePeriodically(every: 30) }

    Task {
      status = await getStatus()
    }
  }

  @discardableResult
  public func insert<T: Convertible>(_ convertible: T) async throws -> T {
    guard status == .available else { throw DatabaseError.status(status) }

    return try await mapToDatabaseError {
      try await database.save(CKRecord.castFrom(databaseObject: try await mapToDatabaseObject(convertible)))
      return convertible
    }
  }

  @discardableResult
  public func delete<T: Convertible>(_: T.Type = T.self, with id: T.ID) async throws -> T? {
    guard status == .available else { throw DatabaseError.status(status) }

    try await mapToDatabaseError {
      try await database.deleteRecord(withID: CKRecord.ID(recordName: id.description))
    }
    
    return nil
  }

  public func fetch<T: Convertible>(_: T.Type = T.self, with id: T.ID) async throws -> T? {
    guard status != .unavailable else { throw DatabaseError.status(.unavailable) }

    return try await mapToDatabaseError {
      try await fetchDatabaseObject(T.self, with: id).flatMap(T.init)
    }
  }

  public func fetch<T: Convertible>(_ query: Query<T>) throws -> AsyncThrowingStream<[T], Error> {
    guard status != .unavailable else { throw DatabaseError.status(.unavailable) }
    
    return fetchDatabaseObjects(query)
      .map { $0.map(T.init) }
      .mapError(mapToDatabaseError)
  }
}
