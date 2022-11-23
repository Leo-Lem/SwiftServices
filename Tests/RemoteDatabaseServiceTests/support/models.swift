//	Created by Leopold Lemmermann on 09.11.22.

import Foundation
import RemoteDatabaseService
import Previews
import Queries_KeyPath

public protocol Example1: RemoteModelConvertible, HasExample, KeyPathQueryable
  where Self: Identifiable & Equatable, ID == UUID
{
  var id: UUID { get }
  var value: Int { get set }

  init(id: ID, value: Int)
}

public protocol Example2: RemoteModelConvertible, HasExample, KeyPathQueryable
  where Self: Identifiable & Equatable, ID == UUID
{
  var id: UUID { get }
  var value: Bool { get set }

  init(id: ID, value: Bool)
}

public extension Example1 {
  static var example: Self { Self(id: ID(), value: .random(in: 0 ..< 100)) }
  static var keyPathDictionary: [PartialKeyPath<Self>: String] { [\.id: "id", \.value: "value"] }
}

public extension Example2 {
  static var example: Self { Self(id: ID(), value: .random()) }
  static var keyPathDictionary: [PartialKeyPath<Self>: String] { [\.id: "id", \.value: "value"] }
}
