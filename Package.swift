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
  errors: "Errors",
  misc: "LeosMisc"
)

for name in [mine.keyValue, mine.haptics, mine.errors, mine.misc] {
  package.dependencies.append(.package(url: "https://github.com/Leo-Lem/\(name)", branch: "main"))
}

// MARK: - (TARGETS)

let service = Target.target(name: "AuthenticationService")

let ui = Target.target(
  name: "AuthenticationUI",
  dependencies: [
    .target(name: service.name),
    .byName(name: mine.haptics),
    .byName(name: mine.errors),
    .byName(name: mine.misc)
  ],
  resources: [.process("res")]
)

let implementation = Target.target(
  name: "MyAuthenticationService",
  dependencies: [
    .target(name: service.name),
    .byName(name: mine.keyValue),
    .byName(name: mine.errors)
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
  ],
  resources: [.process("devServer")]
)

package.targets = [service, ui, implementation, tests, mockTests, implTests]

// MARK: - (PRODUCTS)

package.products.append(
  .library(name: package.name, targets: [service.name, ui.name, implementation.name])
)
