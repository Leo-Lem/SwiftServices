//	Created by Leopold Lemmermann on 02.12.22.

@available(iOS 15, macOS 12, *)
public extension DatabaseService {
  var events: AsyncStream<DatabaseEvent> { eventPublisher.stream }
}
