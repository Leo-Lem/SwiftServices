//	Created by Leopold Lemmermann on 09.11.22.

import RemoteDatabaseService

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension CloudKitService {
  func fetch<T: RemoteModelConvertible>(with id: T.ID, _: T.Type = T.self) async throws -> T.RemoteModel? {
    do {
      return try verifyIsRemoteModel(try await database.record(for: .init(recordName: id.description)), T.self)
    } catch let error as CKError where error.code == .unknownItem {
      return nil
    }
  }

  func fetch<T: RemoteModelConvertible>(_ query: Query<T>) -> AsyncThrowingStream<[T.RemoteModel], Error> {
    fetch(
      ckQuery: getCKQuery(from: query),
      maxItems: query.options.maxItems,
      batchSize: query.options.batchSize
    )
    .map { records in
      try records.map {
        try self.verifyIsRemoteModel($0, T.self)
      }
    }
  }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension CloudKitService {
  func fetch(ckQuery: CKQuery, maxItems: Int?, batchSize: Int) -> AsyncThrowingStream<[CKRecord], Error> {
    AsyncThrowingStream { [weak self] continuation in
      do {
        guard let database = self?.database else { return continuation.finish() }

        var count = 0,
            cursor: CKQueryOperation.Cursor?

        try handleResult(
          try await database.records(matching: ckQuery, inZoneWith: nil, desiredKeys: nil, resultsLimit: batchSize)
        )

        while let c = cursor {
          try handleResult(
            try await database.records(continuingMatchFrom: c, desiredKeys: nil, resultsLimit: batchSize)
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
