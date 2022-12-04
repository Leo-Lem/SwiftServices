@testable import CoreSpotlightService
import BaseTests

class CoreSpotlightServiceTests: BaseTests<CoreSpotlightService, ExampleImpl> {
  override func setUpWithError() throws {
    service = CoreSpotlightService()
  }
}
