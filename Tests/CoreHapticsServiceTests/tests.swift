@testable import CoreHapticsService
import HapticsServiceTests

class CoreHapticsServiceTests: HapticsServiceTests {
  override func setUpWithError() throws {
    service = CoreHapticsService()
  }
}
