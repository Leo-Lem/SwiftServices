import BaseTests
@testable import CoreDataService

@available(iOS 15, macOS 12, *)
class CoreDataServiceIntegrationTests: BaseTests<CoreDataService, Example1, Example2> {
  override func setUp() async throws {
    service = IntegratedCoreDataService()

    try await service.deleteAll(Example1.self)
    try await service.deleteAll(Example2.self)
  }
}

@available(iOS 15, macOS 12, *)
class IntegratedCoreDataService: CoreDataService {
  static let containerID = "Main"

  static let managedObjectModel: NSManagedObjectModel = {
    guard
      let url = Bundle.module.url(forResource: containerID, withExtension: "momd") ??
      Bundle.main.url(forResource: containerID, withExtension: "momd") ??
      Bundle(for: IntegratedCoreDataService.self).url(forResource: containerID, withExtension: "momd")
    else {
      fatalError("Failed to locate model file.")
    }

    guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
      fatalError("Failed to load model file.")
    }

    return managedObjectModel
  }()

  init() {
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

    super.init(container: container)
  }
}
