//	Created by Leopold Lemmermann on 08.11.22.

import Errors

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension CoreDataService {
  nonisolated func fetchDatabaseObject<T: Convertible>(of: T.Type, with id: T.ID) -> T.DatabaseObject? {
    fetchDatabaseObjects(Query<T>("id", .equal, id.description)).first
  }

  nonisolated func fetchDatabaseObjects<T: Convertible>(_ query: Query<T>) -> [T.DatabaseObject] {
    printError {
      try context.fetch(query.getNSFetchRequest())
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
