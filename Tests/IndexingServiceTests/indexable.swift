//	Created by Leopold Lemmermann on 17.11.22.

import Foundation
import IndexingService
import Previews

public protocol Example: Indexable, HasExample, Identifiable where ID == UUID {
  var id: UUID { get }
  var title: String { get set }
  var details: String { get set }

  init(id: ID, title: String, details: String)
}

public extension Example {
  func getTitle() -> String? { title }
  func getDetails() -> String? { details }
  static var example: Self {
    Self(id: ID(), title: .random(in: 0 ..< 10), details: .random(in: 0 ..< 10))
  }
}
