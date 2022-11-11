//	Created by Leopold Lemmermann on 11.11.22.

extension Array {
  func map<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
    var values = [T]()
    for element in self {
      values.append(try await transform(element))
    }
    return values
  }
  
  func compactMap<T>(_ transform: (Element) async throws -> T?) async rethrows -> [T] {
    var values = [T]()
    for element in self {
      if let newElement = try await transform(element) { values.append(newElement) }
    }
    return values
  }
}
