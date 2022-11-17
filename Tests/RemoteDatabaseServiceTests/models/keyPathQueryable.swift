//	Created by Leopold Lemmermann on 09.11.22.

import Queries_KeyPath

extension Example1: KeyPathQueryable {
  public static let keyPathDictionary: [PartialKeyPath<Self>: String] = [\.id: "id", \.value: "value"]
}

extension Example2: KeyPathQueryable {
  public static let keyPathDictionary: [PartialKeyPath<Self>: String] = [\.id: "id", \.value: "value"]
}
