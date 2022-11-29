//	Created by Leopold Lemmermann on 09.11.22.

import CloudKit
import RemoteDatabaseService
import Errors

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension CloudKitService {
  @available(iOS 15, macOS 12, *)
  func statusUpdateOnCloudKitChange() -> Task<Void, Never> {
    NotificationCenter.default
      .publisher(for: .CKAccountChanged)
      .getTask(operation: updateStatus)
  }
  
  @available(iOS 15, macOS 12, *)
  func periodicRefresh(every interval: TimeInterval) -> Task<Void, Never> {
    Timer
      .publish(every: interval, on: .main, in: .default)
      .getTask { [weak self] _ in self?.didChange.send(.remote) }
  }
  
  func updateStatus(_: Notification? = nil) async {
    await printError {
      let newStatus: RemoteDatabaseStatus

      do {
        newStatus = try await container.accountStatus() == .available ? .available : .readOnly
      } catch let error as CKError where error.code == .networkFailure || error.code == .networkUnavailable {
        newStatus = .unavailable
      }

      if newStatus != status {
        status = newStatus
        didChange.send(.status(newStatus))
      }
    }
  }
}
