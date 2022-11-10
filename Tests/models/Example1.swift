//	Created by Leopold Lemmermann on 09.11.22.

import Foundation

struct Example1: Identifiable, Equatable {
  let id: UUID
  var value: Int

  init(
    id: UUID = UUID(),
    value: Int = .random(in: 0 ..< 100)
  ) {
    self.id = id
    self.value = value
  }
}
