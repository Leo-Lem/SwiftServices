//  Created by Leopold Lemmermann on 07.10.22.

import Concurrency
@_exported import CoreData
@_exported import DatabaseService
import Errors

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
open class CoreDataService: DatabaseService {
  public typealias Convertible = DatabaseObjectConvertible

  public internal(set) var status = DatabaseStatus.available
  public let eventPublisher = DatabaseEventPublisher()
  public let container: NSPersistentContainer

  private let tasks = Tasks()

  /// Instantiates a CoreDataService with the given container.
  /// - Parameter container: The NSPersistentContainer to use.
  public init(container: NSPersistentContainer) {
    self.container = container

    tasks.add(updateOnRemoteChange, saveOnResignActive)
  }

  @discardableResult
  public func insert<T: Convertible>(_ convertible: T) -> T {
    container.viewContext.insert(NSManagedObject.castFrom(databaseObject: getDatabaseObject(from: convertible)))

    save()
    eventPublisher.send(.inserted(convertible))

    return convertible
  }

  public func delete<T: Convertible>(_: T.Type, with id: T.ID) throws {
    guard let object = fetchDatabaseObject(of: T.self, with: id) else {
      throw DatabaseError.doesNotExist(T.self, id: id)
    }

    container.viewContext.delete(NSManagedObject.castFrom(databaseObject: object))

    save()
    eventPublisher.send(.deleted(T.self, id: id))
  }

  public func fetch<T: Convertible>(with id: T.ID) -> T? {
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
