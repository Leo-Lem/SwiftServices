//	Created by Leopold Lemmermann on 09.11.22.

import CloudKit
import Queries
import RemoteDatabaseService

extension CloudKitService {
  func fetch<T: RemoteModelConvertible>(with id: T.ID, _: T.Type = T.self) async throws -> T.RemoteModel? {
    do {
      return try verifyIsRemoteModel(try await database.record(for: .init(recordName: id.description)), T.self)
    } catch let error as CKError where error.code == .unknownItem {
      return nil
    }
  }

  func fetchAndCollect<T: RemoteModelConvertible>(_ query: Query<T>) async throws -> [T.RemoteModel] {
    try await fetch(query).collect()
  }

  func fetch<T: RemoteModelConvertible>(_ query: Query<T>) -> AsyncThrowingStream<T.RemoteModel, Error> {
    fetch(
      ckQuery: getCKQuery(from: query),
      maxItems: query.options.maxItems
    )
    .map { try self.verifyIsRemoteModel($0, T.self) }
  }
}

extension CloudKitService {
  func fetch(ckQuery: CKQuery, maxItems: Int?) -> AsyncThrowingStream<CKRecord, Error> {
    AsyncThrowingStream { continuation in
      Task { [weak self] in
        do {
          guard let database = self?.database else { return continuation.finish() }

          var count = 0
          var cursor: CKQueryOperation.Cursor?

          let result = try await database.records(matching: ckQuery, resultsLimit: 1)
          cursor = result.queryCursor
          if let record = try result.matchResults.first?.1.get() {
            continuation.yield(record)
          }

          while let c = cursor {
            let result = try await database.records(continuingMatchFrom: c, resultsLimit: 1)
            cursor = result.queryCursor
            count += 1
            if let record = try result.matchResults.first?.1.get() {
              continuation.yield(record)
            }

            if let max = maxItems, count > max {
              continuation.finish()
            }
          }

          continuation.finish()
        } catch {
          continuation.finish(throwing: error)
        }
      }
    }
  }
}
