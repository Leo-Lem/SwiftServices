//	Created by Leopold Lemmermann on 20.10.22.

extension UNNotificationRequest {
  convenience init<T: PushNotification>(pushNotification: T) {
    let content = UNMutableNotificationContent()
    content.sound = .default
    content.title = pushNotification.title
    if let subtitle = pushNotification.subtitle, !subtitle.isEmpty {
      content.subtitle = subtitle
    }
    
    let trigger = UNCalendarNotificationTrigger(
      dateMatching: Calendar.current.dateComponents([.hour, .minute], from: pushNotification.scheduleFor),
      repeats: true
    )
    
    self.init(
      identifier: pushNotification.id.description,
      content: content,
      trigger: trigger
    )
  }
}
