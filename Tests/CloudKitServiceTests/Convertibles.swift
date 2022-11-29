//	Created by Leopold Lemmermann on 08.11.22.

import CloudKitService
import BaseTests

struct Example1Impl: Example1 {
  static let typeID = "Example1"
  
  let id: UUID
  var value: Int

  init(id: ID, value: Int) {
    self.id = id
    self.value = value
  }

  func mapProperties(onto remoteModel: CKRecord) -> CKRecord {
    remoteModel["value"] = value
    
    return remoteModel
  }

  init(from remoteModel: CKRecord) {
    self.init(
      id: UUID(uuidString: remoteModel.recordID.recordName) ?? UUID(),
      value: remoteModel["value"] as? Int ?? 0
    )
  }
}

struct Example2Impl: Example2 {
  static let typeID = "Example2"

  let id: UUID
  var value: Bool

  init(id: ID, value: Bool) {
    self.id = id
    self.value = value
  }
  
  func mapProperties(onto remoteModel: CKRecord) -> CKRecord {
    remoteModel["value"] = value
    
    return remoteModel
  }

  init(from remoteModel: CKRecord) {
    self.init(
      id: UUID(uuidString: remoteModel.recordID.recordName) ?? UUID(),
      value: remoteModel["value"] as? Bool ?? false
    )
  }
}
