// Created by Leopold Lemmermann on 12.12.22.

import Errors

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension CoreDataService {
  func save() async {
    await printError {
      try await context.perform { [weak self] in
        if self?.context.hasChanges ?? false { try self?.context.save() }
      }
    }
  }
}
