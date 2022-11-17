//	Created by Leopold Lemmermann on 23.10.22.

import CloudKit
import Combine
import Concurrency
import Queries
import RemoteDatabaseService

open class CloudKitService: RemoteDatabaseService {
  public internal(set) var status: RemoteDatabaseStatus = .unavailable

  public let didChange = PassthroughSubject<RemoteDatabaseChange, Never>()

  let container: CloudKitContainer
  private let scope: CloudKitDatabaseScope
  var database: CloudKitDatabase { container.database(with: scope) }

  private let tasks = Tasks()

  public init(_ container: CloudKitContainer, scope: CloudKitDatabaseScope = .public) async {
    self.container = container
    self.scope = scope

    if #available(iOS 15, macOS 12, *) {
      tasks.add(statusUpdateOnCloudKitChange(), periodicRefresh(every: 60))
    }

    await updateStatus()
  }

  @discardableResult
  public func publish<T: RemoteModelConvertible>(_ convertible: T) async throws -> T {
    try await mapToCloudKitError {
      try await database.save(
        try verifyIsCKRecord(remoteModel: try await mapToRemoteModel(convertible))
      )

      didChange.send(.published(convertible))

      return convertible
    }
  }

  public func unpublish<T: RemoteModelConvertible>(with id: T.ID, _: T.Type = T.self) async throws {
    try await mapToCloudKitError {
      try await database.deleteRecord(withID: CKRecord.ID(recordName: id.description))
      didChange.send(.unpublished(id: id, T.self))
    }
  }

  public func fetch<T: RemoteModelConvertible>(with id: T.ID) async throws -> T? {
    try await mapToCloudKitError {
      do {
        return try await fetch(with: id, T.self)
          .flatMap(T.init)
      } catch let error as CKError where error.code == .unknownItem {
        return nil
      }
    }
  }

  public func fetch<T: RemoteModelConvertible>(_ query: Query<T>) -> AsyncThrowingStream<[T], Error> {
    fetch(query)
      .map { $0.map(T.init) }
      .mapError(mapToCloudKitError)
  }
}
