//	Created by Leopold Lemmermann on 20.10.22.

import Foundation

public protocol Indexable: Identifiable where ID: CustomStringConvertible {
  func getTitle() -> String?
  func getDetails() -> String?
  func getAccount() -> String?
  func getUserCreated() -> Bool?
  func getSupportsNavigation() -> Bool?
  func getAddedDate() -> Date?
  
  static func getDescription() -> String?
}

public extension Indexable {
  func getTitle() -> String? { nil }
  func getDetails() -> String? { nil }
  func getAccount() -> String? { nil }
  func getUserCreated() -> Bool? { nil }
  func getSupportsNavigation() -> Bool? { nil }
  func getAddedDate() -> Date? { nil }
  
  static func getDescription() -> String? { nil }
}
