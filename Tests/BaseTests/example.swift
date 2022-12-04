//	Created by Leopold Lemmermann on 20.10.22.

import Foundation

public struct Example: PushNotification {
  public let id = UUID()
  public var title = "Hello there"
  public var subtitle: String? = "GENERAL KENOBI"
  public var scheduleFor = Date()
}
