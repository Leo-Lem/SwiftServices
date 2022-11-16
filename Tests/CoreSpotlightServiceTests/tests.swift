@testable import CoreSpotlightService
import IndexingServiceTests

class CoreSpotlightServiceTests: IndexingServiceTests {
  override func setUpWithError() throws {
    service = CoreSpotlightService()
  }
}
