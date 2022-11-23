@testable import CoreSpotlightService
import IndexingServiceTests

class CoreSpotlightServiceTests: IndexingServiceTests<ExampleImpl> {
  override func setUpWithError() throws {
    service = CoreSpotlightService()
  }
}
