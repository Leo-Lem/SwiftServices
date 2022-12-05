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
  public func insert<T: Convertible>(_ convertible: T) async -> T {
    container.viewContext.insert(NSManagedObject.castFrom(databaseObject: await getDatabaseObject(from: convertible)))
    
    eventPublisher.send(.inserted(T.self, id: convertible.id))
    
    return convertible
  }

  public func delete<T: Convertible>(_: T.Type, with id: T.ID) async throws {
    guard let object = await fetchDatabaseObject(of: T.self, with: id) else {
      throw DatabaseError.doesNotExist(T.self, id: id)
    }

    container.viewContext.delete(NSManagedObject.castFrom(databaseObject: object))

    eventPublisher.send(.deleted(T.self, id: id))
  }

  public func fetch<T: Convertible>(_: T.Type = T.self, with id: T.ID) async -> T? {
    printError(container.viewContext.save)
    
    var databaseObject: T.DatabaseObject?
    let timeout = Date()
    
    repeat {
      databaseObject = await fetchDatabaseObject(of: T.self, with: id)
    } while databaseObject == nil && timeout.distance(to: Date()) < 1
    
    return databaseObject.flatMap(T.init)
  }

  public func fetch<T: Convertible>(_ query: Query<T>) -> AsyncThrowingStream<[T], Error> {
    printError(container.viewContext.save)
    
    return AsyncThrowingStream<[T], Error> { continuation in
      continuation.yield(await self.fetchDatabaseObjects(query).map(T.init))
      continuation.finish()
    }
  }
}
