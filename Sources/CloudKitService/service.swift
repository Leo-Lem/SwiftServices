//	Created by Leopold Lemmermann on 23.10.22.

@_exported import CloudKit
import Concurrency
import RemoteDatabaseService

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
open class CloudKitService: RemoteDatabaseService {
  public internal(set) var status: RemoteDatabaseStatus = .unavailable

  public let didChange = DidChangePublisher()

  let container: CloudKitContainer
  private let scope: CloudKitDatabaseScope
  var database: CloudKitDatabase { container.database(with: scope) }

  private let tasks = Tasks()

  public init(_ container: CloudKitContainer, scope: CloudKitDatabaseScope = .public) async {
    self.container = container
    self.scope = scope

    tasks.add(statusUpdateOnCloudKitChange(), periodicRefresh(every: 60))

    await updateStatus()
  }

  @discardableResult
  public func publish<T: RemoteModelConvertible>(_ convertible: T) async throws -> T {
    guard status != .readOnly else { throw RemoteDatabaseError.notAuthenticated }
    guard status != .unavailable else { throw RemoteDatabaseError.noNetwork }

    return try await mapToRemoteDatabaseError {
      try await database.save(
        try verifyIsCKRecord(remoteModel: try await mapToRemoteModel(convertible))
      )

      didChange.send(.published(convertible))

      return convertible
    }
  }

  public func unpublish<T: RemoteModelConvertible>(with id: T.ID, _: T.Type = T.self) async throws {
    guard status != .readOnly else { throw RemoteDatabaseError.notAuthenticated }
    guard status != .unavailable else { throw RemoteDatabaseError.noNetwork }

    return try await mapToRemoteDatabaseError {
      try await database.deleteRecord(withID: CKRecord.ID(recordName: id.description))
      didChange.send(.unpublished(id: id, type: T.self))
    }
  }

  public func fetch<T: RemoteModelConvertible>(with id: T.ID) async throws -> T? {
    guard status != .unavailable else { throw RemoteDatabaseError.noNetwork }

    return try await mapToRemoteDatabaseError {
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
      .mapError(mapToRemoteDatabaseError)
  }
}
