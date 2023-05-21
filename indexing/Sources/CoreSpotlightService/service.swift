
@_exported import CoreSpotlight
import Errors
@_exported import IndexingService

open class CoreSpotlightService: IndexingService {
  let app: String?

  public static let activityType = CSSearchableItemActionType,
                    activityID = CSSearchableItemActivityIdentifier

  var index: CSSearchableIndex { .default() }

  public init(appname: String? = nil) { app = appname }

  public func updateReference<T: Indexable>(to indexable: T) async throws {
    try await mapError { error in
      IndexingError.other(error)
    } throwing: {
      try await index.indexSearchableItems([indexable.getCSSearchableItem(app)])
    }
  }

  public func removeReference(with id: String) async throws {
    try await mapError { error in
      IndexingError.other(error)
    } throwing: {
      try await index.deleteSearchableItems(withIdentifiers: [id])
    }
  }
}
