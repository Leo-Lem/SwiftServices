//	Created by Leopold Lemmermann on 08.11.22.

import CloudKit
import RemoteDatabaseService

extension Example1: RemoteModelConvertible {
  typealias RemoteModel = CKRecord
  static let typeID = "Example1"

  func mapProperties(onto remoteModel: RemoteModel) -> RemoteModel {
    remoteModel["value"] = value
    
    return remoteModel
  }

  init(from remoteModel: RemoteModel) {
    self.init(
      id: UUID(uuidString: remoteModel.recordID.recordName) ?? UUID(),
      value: remoteModel["value"] as? Int ?? 0
    )
  }
}

extension Example2: RemoteModelConvertible {
  typealias RemoteModel = CKRecord
  static let typeID = "Example2"

  func mapProperties(onto remoteModel: RemoteModel) -> RemoteModel {
    remoteModel["value"] = value
    
    return remoteModel
  }

  init(from remoteModel: RemoteModel) {
    self.init(
      id: UUID(uuidString: remoteModel.recordID.recordName) ?? UUID(),
      value: remoteModel["value"] as? Bool ?? false
    )
  }
}
