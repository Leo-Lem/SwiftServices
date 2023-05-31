// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "SwiftServices",
  defaultLocalization: "en",
  platforms: [.iOS(.v16)]
)

var libraryTargets = [String]()

// MARK: - (DEPENDENCIES)

package.dependencies = [
  .package(url: "https://github.com/leo-lem/leosswift", branch: "main")
]

// MARK: - (DATABASE)

let database = Target.target(
  name: "DatabaseService",
  dependencies: [
    .product(name: "Queries", package: "LeosSwift"),
    .product(name: "LeosMisc", package: "LeosSwift")
  ],
  path: "src/database/base"
)

let cloudkit = Target.target(
  name: "CloudKitService",
  dependencies: [
    .target(name: database.name),
    .product(name: "Errors", package: "LeosSwift")
  ],
  path: "src/database/cloudkit"
)

let coredata = Target.target(
  name: "CoreDataService",
  dependencies: [
    .target(name: database.name),
    .product(name: "Concurrency", package: "LeosSwift")
  ],
  path: "src/database/coredata"
)

let databaseTests = Target.target(
  name: "\(database.name)Tests",
  dependencies: [
    .target(name: database.name),
    .product(name: "Previews", package: "LeosSwift")
  ],
  path: "test/database/base"
)

let cloudkitTests = Target.testTarget(
  name: "\(cloudkit.name)Tests",
  dependencies: [
    .target(name: cloudkit.name),
    .target(name: databaseTests.name)
  ],
  path: "test/database/cloudkit"
)

let coredataTests = Target.testTarget(
  name: "\(coredata.name)Tests",
  dependencies: [
    .target(name: coredata.name),
    .target(name: databaseTests.name)
  ],
  path: "test/database/coredata"
)

package.targets += [database, cloudkit, coredata, databaseTests, cloudkitTests, coredataTests]

package.products += [.library(name: database.name, targets: [database.name, cloudkit.name, coredata.name])]

// MARK: - (<#Next#>)

