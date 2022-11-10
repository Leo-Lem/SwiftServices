//	Created by Leopold Lemmermann on 21.10.22.

public protocol RemoteModelConvertible: StringIdentifiable {
  associatedtype RemoteModel
  
  static var typeID: String { get }

  init(from remoteModel: RemoteModel)
  func mapProperties(onto remoteModel: RemoteModel) -> RemoteModel
}
