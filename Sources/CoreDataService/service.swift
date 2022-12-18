//  Created by Leopold Lemmermann on 07.10.22.

import Concurrency
@_exported import CoreData
@_exported import DatabaseService
import Errors

public protocol CoreDataServicing: DatabaseService {}
extension MockDatabaseService: CoreDataServicing {}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public actor CoreDataService: CoreDataServicing {
  public typealias Convertible = DatabaseObjectConvertible

  public let status = DatabaseStatus.available
  public let eventPublisher = Publisher<DatabaseEvent>()
  public let context: NSManagedObjectContext

  internal let tasks = Tasks()

  /// Instantiates a CoreDataService with the given container.
  /// - Parameter container: The NSPersistentContainer to use.
  public init(context: NSManagedObjectContext, saveEvery saveInterval: TimeInterval = 30) async {
    self.context = context

    tasks["updateOnRemoteChange"] = Task(priority: .background) { await updateOnRemoteChange() }
    tasks["saveOnResignActive"] = Task(priority: .high) { await saveOnResignActive() }
    tasks["savePeriodically"] = Task(priority: .high) { await save(every: saveInterval) }
  }

  @discardableResult
  public func insert<T: Convertible>(_ convertible: T) async -> T {
    await context.perform { [weak self] in
      if let self {
        self.context.insert(
          NSManagedObject.castFrom(databaseObject: self.getDatabaseObject(from: convertible))
        )
      }
    }

    eventPublisher.send(.inserted(T.self, id: convertible.id))

    return convertible
  }

  public func delete<T: Convertible>(_: T.Type, with id: T.ID) async throws {
    try await context.perform { [weak self] in
      if let self {
        guard let object = self.fetchDatabaseObject(of: T.self, with: id) else {
          throw DatabaseError.doesNotExist(T.self, id: id)
        }

        self.context.delete(NSManagedObject.castFrom(databaseObject: object))
      }
    }

    eventPublisher.send(.deleted(T.self, id: id))
  }

  public func fetch<T: Convertible>(_: T.Type = T.self, with id: T.ID) async -> T? {
    await save()
    
    return await context.perform { [weak self] in
      return self?.fetchDatabaseObject(of: T.self, with: id).flatMap(T.init)
    }
  }

  public func fetch<T: Convertible>(_ query: Query<T>) async throws -> AsyncThrowingStream<[T], Error> {
    await save()
    
    return await context.perform { [weak self] in
        return AsyncThrowingStream<[T], Error> { continuation in
          continuation.yield(self?.fetchDatabaseObjects(query).map(T.init) ?? [])
          continuation.finish()
        }
    }
  }
}
