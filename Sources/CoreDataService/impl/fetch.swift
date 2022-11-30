//	Created by Leopold Lemmermann on 08.11.22.

import Errors

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension CoreDataService {
  func fetchDatabaseObject<T: Convertible>(of: T.Type, with id: T.ID) -> T.DatabaseObject? {
    fetchDatabaseObjects(Query<T>("id", .equal, id.description)).first
  }

  func fetchDatabaseObjects<T: Convertible>(_ query: Query<T>) -> [T.DatabaseObject] {
    printError {
      try container.viewContext.fetch(query.getNSFetchRequest())
        .map { $0.castToDatabaseObject(of: T.self) }
    } ?? []
  }
}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension Query where ResultType: CoreDataService.Convertible {
  func getNSFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: ResultType.typeID)
    request.predicate = getNSPredicate()
    if let limit = options.maxItems { request.fetchLimit = limit }
    return request
  }
}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension NSManagedObjectContext {
  func fetch(_ request: NSFetchRequest<NSFetchRequestResult>) async throws -> [NSFetchRequestResult] {
    try await withCheckedThrowingContinuation { continuation in
      do {
        try execute(NSAsynchronousFetchRequest(fetchRequest: request) { result in
          continuation.resume(returning: result.finalResult ?? [])
        })
      } catch {
        continuation.resume(throwing: error)
      }
    }
  }
}
