//	Created by Leopold Lemmermann on 18.11.22.

import Foundation

/// A type which can be used to schedule a push notification.
public protocol PushNotification: Identifiable where ID: CustomStringConvertible {
  /// The notification's title.
  var title: String { get }
  /// The notification's subtitle.
  var subtitle: String? { get }
  /// The date to schedule the notification for.
  var scheduleFor: Date { get }
}
