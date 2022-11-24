@testable import PushNotificationService
import XCTest

// !!!:  Subclass these tests and insert an implementation in the setUp method.
// (see mock-tests for example)
open class PushNotificationServiceTests<S: PushNotificationService>: XCTestCase {
  public var service: S!
  
  func testScheduling() async {
    await service.schedule(Example())
  }
  
  func testCancelling() async {
    service.cancel(Example())
  }
}
