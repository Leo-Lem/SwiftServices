//	Created by Leopold Lemmermann on 23.11.22.

import Foundation
import IndexingServiceTests

struct ExampleImpl: Example {
  let id: UUID
  
  var title: String,
      details: String
  
  init(id: UUID, title: String, details: String) {
    self.id = id
    self.title = title
    self.details = details
  }
}
