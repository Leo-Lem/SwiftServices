//	Created by Leopold Lemmermann on 09.11.22.

import Foundation

struct Example2: Identifiable, Equatable {
  let id: UUID
  var value: Bool

  init(
    id: UUID = UUID(),
    value: Bool = .random()
  ) {
    self.id = id
    self.value = value
  }
}
