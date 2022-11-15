//	Created by Leopold Lemmermann on 09.11.22.

import CloudKit
import RemoteDatabaseService
import Errors

extension CloudKitService {
  func statusUpdateOnCloudKitChange() -> Task<Void, Never> {
    NotificationCenter.default
      .publisher(for: .CKAccountChanged)
      .getTask(operation: updateStatus)
  }

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

