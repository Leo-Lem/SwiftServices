//  Created by Leopold Lemmermann on 08.11.22.

import BaseTests

struct Example1: Example1Protocol {
  static let typeID = "Example1"

  let id: UUID
  var value: Int

  init(id: ID, value: Int) {
    self.id = id
    self.value = value
  }

  func mapProperties(onto databaseObject: inout Self) { databaseObject = self }
  init(from databaseObject: Self) { self = databaseObject }
}

struct Example2: Example2Protocol {
  static let typeID = "Example2"

  let id: UUID
  var value: Bool

  init(id: ID, value: Bool) {
    self.id = id
    self.value = value
  }

  func mapProperties(onto databaseObject: inout Self) { databaseObject = self }
  init(from databaseObject: Self) { self = databaseObject }
}
