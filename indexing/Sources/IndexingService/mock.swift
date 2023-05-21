//	Created by Leopold Lemmermann on 20.10.22.

public extension IndexingService where Self == MockIndexingService {
  static var mock: MockIndexingService { MockIndexingService() }
}

open class MockIndexingService: IndexingService {
  public init() {}

  public func updateReference<T: Indexable>(to indexable: T) {
    print("Created reference to \(indexable.getTitle() ?? "")!")
  }

  public func removeReference(with id: String) {
    print("Removed reference to \(id)!")
  }
}
