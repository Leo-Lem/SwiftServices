//	Created by Leopold Lemmermann on 30.11.22.

import Errors

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension CloudKitService {
  func updateStatusOnChange() async {
    for await _ in NotificationCenter.default.notifications(named: .CKAccountChanged) {
      let status = await getStatus()
      if status != self.status {
        self.status = status
      }
    }
  }

  func getStatus() async -> DatabaseStatus {
    await printError {
      do {
        return try await container.accountStatus() == .available ? .available : .readOnly
      } catch let error as CKError where error.code == .networkFailure || error.code == .networkUnavailable {
        return .unavailable
      }
    } ?? .unavailable
  }
}
