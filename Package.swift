// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "AuthenticationService",
  defaultLocalization: "en",
  platforms: [.iOS(.v13), .macOS(.v12)]
)

// MARK: - (DEPENDENCIES)

let mine = (
  keyValue: "KeyValueStorageService",
  haptics: "HapticsService",
  concurrency: "Concurrency",
  misc: "LeosMisc"
)

for name in [mine.keyValue, mine.haptics, mine.concurrency, mine.misc] {
  package.dependencies.append(.package(url: "https://github.com/Leo-Lem/\(name)", branch: "main"))
}

// MARK: - (TARGETS)

let service = Target.target(
  name: "AuthenticationService",
  dependencies: [
    .product(name: mine.haptics, package: mine.haptics),
    .product(name: mine.concurrency, package: mine.concurrency),
    .product(name: mine.misc, package: mine.misc)
  ],
  resources: [.process("ui/res")]
)

let implementation = Target.target(
  name: "MyAuthenticationService",
  dependencies: [
    .target(name: service.name),
    .product(name: mine.keyValue, package: mine.keyValue)
  ]
)

let tests = Target.target(
  name: "BaseTests",
  dependencies: [.target(name: service.name)],
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
