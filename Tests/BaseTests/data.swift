//	Created by Leopold Lemmermann on 08.11.22.

import Previews

extension RemoteDatabaseServiceTests {
  func createHeterogenousTestData<T1: Example1, T2: Example2>(
    _ count: Int = 2,
    _: T1.Type,
    _: T2.Type
  ) -> [any RemoteModelConvertible] {
    var convertibles = [any RemoteModelConvertible]()
    
    convertibles.append(contentsOf: createTestData(count / 2) as [T1])
    convertibles.append(contentsOf: createTestData(count / 2) as [T2])
    
    return convertibles
  }

  func createTestData<T: RemoteModelConvertible & HasExample>(_ count: Int = 1) -> [T] {
    var convertibles = [T]()
    for _ in 0 ..< count { convertibles.append(T.example) }
    return convertibles
  }
}
