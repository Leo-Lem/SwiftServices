//	Created by Leopold Lemmermann on 08.11.22.

import BaseTests

struct Example1: Example1Protocol {
  static let typeID = "Example1"
  
  let id: UUID
  var value: Int

  init(id: ID, value: Int) {
    self.id = id
    self.value = value
  }
  
  func mapProperties(onto databaseObject: inout CDExample1) {
    databaseObject.id = id.uuidString
    databaseObject.value = Int16(value)
  }

  init(from databaseObject: CDExample1) {
    self.init(
      id: databaseObject.id.flatMap(UUID.init) ?? UUID(),
      value: Int(databaseObject.value)
    )
  }
}

struct Example2: Example2Protocol {
  static let typeID = "Example2"

  let id: UUID
  var value: Bool

  init(id: ID, value: Bool) {
    self.id = id
    self.value = value
  }
  
  func mapProperties(onto databaseObject: inout CDExample2) {
    databaseObject.id = id.uuidString
    databaseObject.value = value
  }

  init(from databaseObject: CDExample2) {
    self.init(
      id: databaseObject.id.flatMap(UUID.init) ?? UUID(),
      value: databaseObject.value
    )
  }
}
