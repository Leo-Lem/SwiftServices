//	Created by Leopold Lemmermann on 30.11.22.

import Errors

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension CloudKitService {
  func updateStatusOnChange() -> Task<Void, Never> {
    NotificationCenter.default
      .publisher(for: .CKAccountChanged)
      .getTask { [weak self] _ in
        guard let self = self else { return }
        
        let status = await self.getStatus()
        if status != self.status {
          self.status = status
          self.didChange.send(.status(status))
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
