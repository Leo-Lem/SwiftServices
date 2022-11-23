//  Created by Leopold Lemmermann on 08.11.22.

import Foundation
import RemoteDatabaseService

struct Example1Impl: Example1 {
  static let typeID = "Example1"

  let id: UUID
  var value: Int

  init(id: ID, value: Int) {
    self.id = id
    self.value = value
  }

  func mapProperties(onto localModel: Self) -> Self { self }
  init(from localModel: Self) { self = localModel }
}

struct Example2Impl: Example2 {
  static let typeID = "Example2"

  let id: UUID
  var value: Bool

  init(id: ID, value: Bool) {
    self.id = id
    self.value = value
  }

  func mapProperties(onto localModel: Self) -> Self { self }
  init(from localModel: Self) { self = localModel }
}
