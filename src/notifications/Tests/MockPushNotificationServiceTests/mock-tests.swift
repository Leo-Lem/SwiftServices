//	Created by Leopold Lemmermann on 23.11.22.

import BaseTests

class MockPushNotificationServiceTests: PushNotificationServiceTests<MockPushNotificationService> {
  override func setUp() async throws { service = .init() }
}
