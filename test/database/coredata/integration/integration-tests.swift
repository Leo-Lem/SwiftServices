import DatabaseServiceTests
@testable import CoreDataService

@available(iOS 15, macOS 12, *)
class CoreDataServiceIntegrationTests: BaseTests<CoreDataService, Example1, Example2> {
  override func setUp() async throws {
    service = CoreDataService()

    try await service.deleteAll(Example1.self)
    try await service.deleteAll(Example2.self)
  }
  
  func testIssue() async throws {
    for _ in 0..<1000 {
      let example = Example1.example
      await service.insert(example)
      _ = await service.fetch(Example1.self, with: example.id)
      try await service.delete(Example1.self, with: example.id)
    }
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

  convenience init() {
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
    
    self.init(context: container.viewContext)
  }
}
