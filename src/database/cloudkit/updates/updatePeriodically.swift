//	Created by Leopold Lemmermann on 09.11.22.

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension CloudKitService {
  func updatePeriodically(every interval: TimeInterval) async {
    for await _ in Timer.publish(every: interval, on: .main, in: .default).stream {
    }
  }
}
