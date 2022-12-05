//  Created by Leopold Lemmermann on 07.10.22.

import Concurrency
@_exported import CoreData
@_exported import DatabaseService
import Errors

public actor CoreDataService: DatabaseService {
  public typealias Convertible = DatabaseObjectConvertible

  public let status = DatabaseStatus.available
  public let eventPublisher = Publisher<DatabaseEvent>()
  public let container: NSPersistentContainer

  internal let tasks = Tasks()

  /// Instantiates a CoreDataService with the given container.
  /// - Parameter container: The NSPersistentContainer to use.
  @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
  public init(container: NSPersistentContainer) async {
    self.container = container

    tasks["updateOnRemoteChange"] = Task(priority: .background) { await updateOnRemoteChange() }
    tasks["saveOnResignActive"] = Task(priority: .high) { await saveOnResignActive() }
    tasks["savePeriodically"] = Task(priority: .high) { await save(every: 30) }
    
    // TODO: provide an alternative intializer for older versions
//    tasks["updatePeriodically"] = Task(priority: .background) { await update(every: 30) }
  }

  @discardableResult
  public func insert<T: Convertible>(_ convertible: T) -> T {
    container.viewContext.insert(NSManagedObject.castFrom(databaseObject: getDatabaseObject(from: convertible)))

    eventPublisher.send(.inserted(T.self, id: convertible.id))

    return convertible
  }

  public func delete<T: Convertible>(_: T.Type, with id: T.ID) throws {
    guard let object = fetchDatabaseObject(of: T.self, with: id) else {
      throw DatabaseError.doesNotExist(T.self, id: id)
    }

    container.viewContext.delete(NSManagedObject.castFrom(databaseObject: object))

    eventPublisher.send(.deleted(T.self, id: id))
  }

  public func fetch<T: Convertible>(_: T.Type = T.self, with id: T.ID) -> T? {
    fetchDatabaseObject(of: T.self, with: id)
      .flatMap(T.init)
  }

  public func fetch<T: Convertible>(_ query: Query<T>) -> AsyncThrowingStream<[T], Error> {
    AsyncThrowingStream<[T], Error> { continuation in
      continuation.yield(fetchDatabaseObjects(query).map(T.init))
      continuation.finish()
    }
  }
}
