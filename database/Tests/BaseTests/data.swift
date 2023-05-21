//	Created by Leopold Lemmermann on 08.11.22.

import Previews

extension BaseTests {
  func createHeterogenousTestData(
    _ count: Int = 2, _ type1: T1.Type, _ type2: T2.Type
  ) -> [any DatabaseObjectConvertible] {
    var convertibles = [any DatabaseObjectConvertible]()
    
    convertibles.append(contentsOf: createTestData(count / 2) as [T1])
    convertibles.append(contentsOf: createTestData(count / 2) as [T2])
    
    return convertibles
  }

  func createTestData<T: DatabaseObjectConvertible & HasExample>(_ count: Int = 1) -> [T] {
    var convertibles = [T]()
    for _ in 0 ..< count { convertibles.append(T.example) }
    return convertibles
  }
}
