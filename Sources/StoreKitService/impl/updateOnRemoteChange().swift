//	Created by Leopold Lemmermann on 18.11.22.

import StoreKit
import Errors

@available(iOS 15, macOS 12, *)
extension StoreKitService {
  func updateOnRemoteChange() -> Task<Void, Never> {
    Task(priority: .background) {
      await printError {
        for await verification in Transaction.updates {
          try handleTransaction(verification)
        }
      }
    }
  }
}
