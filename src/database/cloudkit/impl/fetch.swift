//	Created by Leopold Lemmermann on 09.11.22.

extension CloudKitService {
  func fetchDatabaseObject<T: Convertible>(_: T.Type, with id: T.ID) async throws -> T.DatabaseObject? {
    do {
      return try await database.record(for: .init(recordName: id.description)).castToDatabaseObject(of: T.self)
    } catch let error as CKError where error.code == .unknownItem { return nil }
  }

  func fetchDatabaseObjects<T: Convertible>(_ query: Query<T>) -> AsyncThrowingStream<[T.DatabaseObject], Error> {
    fetch(
      ckQuery: query.getCKQuery(),
      maxItems: query.options.maxItems,
      batchSize: query.options.batchSize
    )
    .map { records in records.map { $0.castToDatabaseObject(of: T.self) } }
  }
}

extension Query where ResultType: CloudKitService.Convertible {
  func getCKQuery() -> CKQuery {
    CKQuery(recordType: ResultType.typeID, predicate: getNSPredicate())
  }
}

extension CloudKitService {
  func fetch(ckQuery: CKQuery, maxItems: Int?, batchSize: Int) -> AsyncThrowingStream<[CKRecord], Error> {
    AsyncThrowingStream { [weak self] continuation in
      do {
        guard let database = self?.database else { return continuation.finish() }

        var count = 0,
            cursor: CKQueryOperation.Cursor?

        try handleResult(
          try await database.records(matching: ckQuery, resultsLimit: batchSize)
        )

        while let c = cursor {
          try handleResult(
            try await database.records(continuingMatchFrom: c, resultsLimit: batchSize)
          )
        }

        continuation.finish()

        func handleResult(_ result: (
          matchResults: [(CKRecord.ID, Result<CKRecord, Error>)],
          queryCursor: CKQueryOperation.Cursor?
        )) throws {
          cursor = result.queryCursor

          continuation.yield(
            try result.matchResults
              .map(\.1)
              .map { try $0.get() }
          )

          count += batchSize

          if let max = maxItems, count > max {
            continuation.finish()
          }
        }
      } catch {
        continuation.finish(throwing: error)
      }
    }
  }
}
