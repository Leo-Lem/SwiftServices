//	Created by Leopold Lemmermann on 29.10.22.

import Combine

public extension Publisher {
  func getTask(
    _ priority: TaskPriority = .background,
    operation: @escaping (Output) async throws -> Void
  ) -> Task<Void, Failure> where Failure == Error {
    Task(priority: priority) {
      for try await output in values {
        try await operation(output)
      }
    }
  }

  func getTask(
    _ priority: TaskPriority = .background,
    operation: @escaping (Output) async -> Void
  ) -> Task<Void, Never> where Failure == Never {
    Task(priority: priority) {
      for await output in self.values {
        await operation(output)
      }
    }
  }
}
