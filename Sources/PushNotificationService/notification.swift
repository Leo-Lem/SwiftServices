//	Created by Leopold Lemmermann on 18.11.22.

import Foundation

public protocol PushNotification: Identifiable where ID: CustomStringConvertible {
  var title: String { get }
  var subtitle: String? { get }
  var scheduleFor: Date { get }
}
