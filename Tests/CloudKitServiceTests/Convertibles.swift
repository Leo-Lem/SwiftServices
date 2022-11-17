//	Created by Leopold Lemmermann on 08.11.22.

import CloudKit
import RemoteDatabaseService
import RemoteDatabaseServiceTests

extension Example1: RemoteModelConvertible {
  public static let typeID = "Example1"

  public func mapProperties(onto remoteModel: CKRecord) -> CKRecord {
    remoteModel["value"] = value
    
    return remoteModel
  }

  public init(from remoteModel: CKRecord) {
    self.init(
      id: UUID(uuidString: remoteModel.recordID.recordName) ?? UUID(),
      value: remoteModel["value"] as? Int ?? 0
    )
  }
}

extension Example2: RemoteModelConvertible {
  public static let typeID = "Example2"

  public func mapProperties(onto remoteModel: CKRecord) -> CKRecord {
    remoteModel["value"] = value
    
    return remoteModel
  }

  public init(from remoteModel: CKRecord) {
    self.init(
      id: UUID(uuidString: remoteModel.recordID.recordName) ?? UUID(),
      value: remoteModel["value"] as? Bool ?? false
    )
  }
}
