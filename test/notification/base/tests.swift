@_exported @testable import NotificationService
@_exported import XCTest

// !!!:  Subclass these tests and insert an implementation in the setUp method.
open class PushNotificationServiceTests<S: PushNotificationService>: XCTestCase {
  public var service: S!
  
  func testScheduling() async {
    await service.schedule(Example())
  }
  
  func testCancelling() async {
    service.cancel(Example())
  }
}
