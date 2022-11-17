//	Created by Leopold Lemmermann on 09.11.22.

import Foundation

public struct Example1: Identifiable, Equatable {
  public let id: UUID
  public var value: Int

  public init(
    id: UUID = UUID(),
    value: Int = .random(in: 0 ..< 100)
  ) {
    self.id = id
    self.value = value
  }
}

public struct Example2: Identifiable, Equatable {
  public let id: UUID
  public var value: Bool

  public init(
    id: UUID = UUID(),
    value: Bool = .random()
  ) {
    self.id = id
    self.value = value
  }
}
