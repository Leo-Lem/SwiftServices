//	Created by Leopold Lemmermann on 08.11.22.

import RemoteDatabaseService

extension RemoteDatabaseServiceTests {
  func createHeterogenousTestData(_ count: Int = 2) -> [any RemoteModelConvertible] {
    var convertibles = [any RemoteModelConvertible]()
    for _ in 0 ..< count / 2 { convertibles.append(Example1.example) }
    for _ in 0 ..< count / 2 { convertibles.append(Example2.example) }
    return convertibles
  }

  func createTestData<T: RemoteModelConvertible & HasExample>(_ count: Int = 1) -> [T] {
    var convertibles = [T]()
    for _ in 0 ..< count { convertibles.append(T.example) }
    return convertibles
  }
}
