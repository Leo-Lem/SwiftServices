// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "SwiftServices",
  defaultLocalization: "en",
  platforms: [.iOS(.v16), .macOS(.v13)]
)

var libraryTargets = [String]()

// MARK: - (DEPENDENCIES)

package.dependencies = [
  .package(url: "https://github.com/leo-lem/leosswift", from: "0.1.0"),
  .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
]

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

let keychain = Target.target(
  name: "KeychainService",
  dependencies: [
    .target(name: association.name)
  ],
  path: "src/association/keychain"
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

let keychainTests = Target.testTarget(
  name: "\(keychain.name)Tests",
  dependencies: [
    .target(name: keychain.name),
    .target(name: associationTests.name)
  ],
  path: "test/association/keychain"
)

package.targets += [association, userdefaults, keychain, associationTests, userdefaultsTests, keychainTests]
package.products.append(.library(name: association.name, targets: [association.name, userdefaults.name, keychain.name]))

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
    .product(name: "Concurrency", package: "LeosSwift"),
    .product(name: "Errors", package: "LeosSwift")
  ],
  path: "src/database/cloudkit"
)

let coredata = Target.target(
  name: "CoreDataService",
  dependencies: [
    .target(name: database.name),
    .product(name: "Concurrency", package: "LeosSwift"),
    .product(name: "Errors", package: "LeosSwift")
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

// MARK: - (NOTIFICATION)

let notification = Target.target(
  name: "NotificationService",
  dependencies: [
    .product(name: "Concurrency", package: "LeosSwift")
  ],
  path: "src/notification/base"
)

let usernotifications = Target.target(
  name: "UserNotificationsService",
  dependencies: [
    .target(name: notification.name),
    .product(name: "Concurrency", package: "LeosSwift")
  ],
  path: "src/notification/usernotifications"
)

let notificationTests = Target.target(
  name: "\(notification.name)Tests",
  dependencies: [
    .target(name: notification.name)
  ],
  path: "test/notification/base"
)

let usernotificationsTests = Target.testTarget(
  name: "\(usernotifications.name)Tests",
  dependencies: [
    .target(name: usernotifications.name),
    .target(name: notificationTests.name)
  ],
  path: "test/notification/usernotifications"
)

package.targets += [notification, usernotifications, notificationTests, usernotificationsTests]
package.products.append(.library(name: notification.name, targets: [notification.name, usernotifications.name]))

// MARK: - (PURCHASE)

let purchase = Target.target(
  name: "PurchaseService",
  dependencies: [
    .product(name: "Concurrency", package: "LeosSwift"),
    .product(name: "Previews", package: "LeosSwift")
  ],
  path: "src/purchase/base"
)

let purchaseUI = Target.target(
  name: "\(purchase.name)UI",
  dependencies: [
    .target(name: purchase.name),
    .product(name: "LeosMisc", package: "LeosSwift"),
    .product(name: "Errors", package: "LeosSwift"),
    .product(name: "Previews", package: "LeosSwift")
  ],
  path: "src/purchase/ui",
  resources: [.process("res")]
)

let storekit = Target.target(
  name: "StoreKitService",
  dependencies: [
    .target(name: purchase.name),
    .product(name: "Concurrency", package: "LeosSwift"),
    .product(name: "Errors", package: "LeosSwift")
  ],
  path: "src/purchase/storekit"
)

let purchaseTests = Target.target(
  name: "\(purchase.name)Tests",
  dependencies: [
    .target(name: purchase.name)
  ],
  path: "test/purchase/base"
)

let storekitTests = Target.testTarget(
  name: "\(storekit.name)Tests",
  dependencies: [
    .target(name: purchaseTests.name),
    .target(name: storekit.name)
  ],
  path: "test/purchase/storekit"
)

package.targets += [purchase, purchaseUI, storekit, purchaseTests, storekitTests]
package.products.append(.library(name: purchase.name, targets: [purchase.name, purchaseUI.name, storekit.name]))
