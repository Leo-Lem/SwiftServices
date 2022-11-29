// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "RemoteDatabaseService",
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
  name: "RemoteDatabaseService",
  dependencies: [
    .product(name: mine.queries, package: mine.queries),
    .product(name: mine.concurrency, package: mine.concurrency)
  ],
  resources: [.process("ui/res")]
)

let implementation = Target.target(
  name: "CloudKitService",
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
    .product(name: mine.concurrency, package: mine.concurrency),
    .product(name: mine.previews, package: mine.previews)
  ],
  path: "Tests/BaseTests"
)

let mockTests = Target.testTarget(
  name: "Mock\(service.name)Tests",
  dependencies: [.target(name: tests.name)]
)

let implTests = Target.testTarget(
  name: "\(implementation.name)Tests",
  dependencies: [
    .target(name: implementation.name),
    .target(name: tests.name)
  ]
)

package.targets = [service, implementation, tests, mockTests, implTests]

// MARK: - (PRODUCTS)

package.products.append(.library(name: package.name, targets: [service.name, implementation.name]))
