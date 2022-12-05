//	Created by Leopold Lemmermann on 08.11.22.

import Concurrency

extension CoreDataService {
  @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
  func updateOnRemoteChange() async {
    for await _ in NotificationCenter.default.notifications(named: .NSPersistentStoreRemoteChange) {
      eventPublisher.send(.remote)
    }
  }
  
  @available(iOS, obsoleted: 15)
  @available(macOS, obsoleted: 12)
  @available(tvOS, obsoleted: 15)
  @available(watchOS, obsoleted: 8)
  func update(every interval: TimeInterval) async {
    for await _ in Timer.publish(every: interval, on: .main, in: .common).stream {
      eventPublisher.send(.remote)
    }
  }

}
