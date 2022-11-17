//	Created by Leopold Lemmermann on 17.11.22.

import IndexingService
import Foundation

struct Example: Indexable {
  let id = UUID()
  
  let title: String
  let details: String
  
  func getTitle() -> String? { title }
  
  func getDetails() -> String? { details }
}
