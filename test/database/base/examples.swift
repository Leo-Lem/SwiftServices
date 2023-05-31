//	Created by Leopold Lemmermann on 09.11.22.

import Previews

public protocol Example1Protocol: DatabaseObjectConvertible, HasExample, KeyPathQueryable
  where Self: Identifiable & Equatable, ID == UUID
{
  var id: UUID { get }
  var value: Int { get set }

  init(id: ID, value: Int)
}

public extension Example1Protocol {
  static var example: Self { Self(id: ID(), value: .random(in: 0 ..< 100)) }
  static var propertyNames: [PartialKeyPath<Self>: String] { [\.id: "id", \.value: "value"] }
}

public protocol Example2Protocol: DatabaseObjectConvertible, HasExample, KeyPathQueryable
  where Self: Identifiable & Equatable, ID == UUID
{
  var id: UUID { get }
  var value: Bool { get set }

  init(id: ID, value: Bool)
}
public extension Example2Protocol {
  static var example: Self { Self(id: ID(), value: .random()) }
  static var propertyNames: [PartialKeyPath<Self>: String] { [\.id: "id", \.value: "value"] }
}
