//	Created by Leopold Lemmermann on 08.11.22.

import Errors

extension CoreDataService {
  func fetchDatabaseObject<T: Convertible>(of: T.Type, with id: T.ID) async -> T.DatabaseObject? {
    await fetchDatabaseObjects(Query<T>("id", .equal, id.description)).first
  }

  func fetchDatabaseObjects<T: Convertible>(_ query: Query<T>) async -> [T.DatabaseObject] {
    await printError {
      try await container.viewContext.fetch(query.getNSFetchRequest())
        .map { $0.castToDatabaseObject(of: T.self) }
    } ?? []
  }
}

extension Query where ResultType: CoreDataService.Convertible {
  func getNSFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: ResultType.typeID)
    request.predicate = getNSPredicate()
    if let limit = options.maxItems { request.fetchLimit = limit }
    return request
  }
}

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
