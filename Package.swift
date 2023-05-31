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

package.products.append(.library(name: database.name, targets: [database.name, cloudkit.name, coredata.name]))

// MARK: - (ASSOCIATION)

let association = Target.target(
  name: "AssociationService",
  path: "src/association/base"
)

let userdefaults = Target.target(
  name: "UserDefaultsService",
  dependencies: [
    .target(name: association.name),
    .product(name: "Concurrency", package: "LeosSwift")
  ],
  path: "src/association/userdefaults"
)

let associationTests = Target.target(
  name: "\(association.name)Tests",
  dependencies: [
    .target(name: association.name)
  ],
  path: "test/association/base"
)

let userdefaultsTests = Target.testTarget(
  name: "\(userdefaults.name)Tests",
  dependencies: [
    .target(name: userdefaults.name),
    .target(name: associationTests.name)
  ],
  path: "test/association/userdefaults"
)


package.targets += [association, userdefaults, associationTests, userdefaultsTests]
package.products.append(.library(name: association.name, targets: [association.name, userdefaults.name]))

// MARK: - (AUTHENTICATION)

let authentication = Target.target(
  name: "AuthenticationService",
  dependencies: [
    .product(name: "Concurrency", package: "LeosSwift")
  ],
  path: "src/authentication/base"
)

let authenticationUI = Target.target(
  name: "\(authentication.name)UI",
  dependencies: [
    .target(name: authentication.name),
    .product(name: "Errors", package: "LeosSwift"),
    .product(name: "LeosMisc", package: "LeosSwift")
  ],
  path: "src/authentication/ui",
  resources: [.process("res")]
)

let authenticationTests = Target.target(
  name: "\(authentication.name)Tests",
  dependencies: [
    .target(name: authentication.name)
  ],
  path: "test/authentication/base"
)

package.targets += [authentication, authenticationUI, authenticationTests]
package.products.append(.library(name: authentication.name, targets: [authentication.name, authenticationUI.name]))
