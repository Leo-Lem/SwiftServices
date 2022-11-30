// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "DatabaseService",
  defaultLocalization: "en",
  platforms: [.iOS(.v13), .macOS(.v10_15)]
)

// MARK: - (DEPENDENCIES)

let mine = (queries: "Queries", concurrency: "Concurrency", errors: "Errors", previews: "Previews")

for name in [mine.queries, mine.concurrency, mine.errors, mine.previews] {
  package.dependencies.append(.package(url: "https://github.com/Leo-Lem/\(name)", branch: "main"))
}

// MARK: - (TARGETS)

let service = Target.target(
  name: "DatabaseService",
  dependencies: [
    .byName(name: mine.queries),
    .byName(name: mine.concurrency)
  ],
  resources: [.process("ui/res")]
)

let cloudkit = Target.target(
  name: "CloudKitService",
  dependencies: [
    .target(name: service.name),
    .byName(name: mine.concurrency),
    .byName(name: mine.errors)
  ]
)

let coredata = Target.target(
  name: "CoreDataService",
  dependencies: [
    .target(name: service.name),
    .product(name: mine.concurrency, package: mine.concurrency),
    .product(name: mine.errors, package: mine.errors)
  ]
)

let tests = Target.target(
  name: "BaseTests",
  dependencies: [
    .target(name: service.name),
    .byName(name: mine.concurrency),
    .byName(name: mine.previews)
  ],
  path: "Tests/BaseTests"
)

let mockTests = Target.testTarget(
  name: "Mock\(service.name)Tests",
  dependencies: [.target(name: tests.name)]
)

let cloudkitTests = Target.testTarget(
  name: "\(cloudkit.name)Tests",
  dependencies: [
    .target(name: cloudkit.name),
    .target(name: tests.name)
  ]
)

let coredataTests = Target.testTarget(
  name: "\(coredata.name)Tests",
  dependencies: [
    .target(name: coredata.name),
    .target(name: tests.name)
  ],
  resources: [.process("integration/Main.xcdatamodeld")]
)

package.targets = [service, cloudkit, coredata, tests, mockTests, cloudkitTests, coredataTests]

// MARK: - (PRODUCTS)

package.products.append(
  .library(name: package.name, targets: [service.name, tests.name, cloudkit.name, coredata.name])
)
