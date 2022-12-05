import BaseTests
@testable import CoreDataService

@available(iOS 15, macOS 12, *)
class CoreDataServiceIntegrationTests: BaseTests<CoreDataService, Example1, Example2> {
  override func setUp() async throws {
    service = await CoreDataService()

    try await service.deleteAll(Example1.self)
    try await service.deleteAll(Example2.self)
  }
}

@available(iOS 15, macOS 12, *)
extension CoreDataService {
  static let containerID = "Main"

  static let managedObjectModel: NSManagedObjectModel = {
    guard
      let url = Bundle.module.url(forResource: containerID, withExtension: "momd") ??
      Bundle.main.url(forResource: containerID, withExtension: "momd") ??
      Bundle(for: CoreDataServiceIntegrationTests.self).url(forResource: containerID, withExtension: "momd")
    else {
      fatalError("Failed to locate model file.")
    }

    guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
      fatalError("Failed to load model file.")
    }

    return managedObjectModel
  }()

  init() async {
    let container = NSPersistentContainer(
      name: Self.containerID,
      managedObjectModel: Self.managedObjectModel
    )

    container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

    container.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Failed to load persistent store: \(error.localizedDescription)")
      }
    }
    
    await self.init(container: container)
  }
}
