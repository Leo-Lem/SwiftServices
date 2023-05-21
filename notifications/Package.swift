// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "PushNotificationService",
  platforms: [.iOS(.v13), .macOS(.v10_15)]
)

// MARK: - (DEPENDENCIES)

let concurrency = "Concurrency"

for name in [concurrency] {
  package.dependencies.append(.package(url: "https://github.com/Leo-Lem/\(name)", branch: "main"))
}

// MARK: - (TARGETS)

let service = Target.target(
  name: "PushNotificationService",
  dependencies: [.byName(name: concurrency)]
)

let impl = Target.target(
  name: "UserNotificationsService",
  dependencies: [
    .target(name: service.name),
      .byName(name: concurrency)
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
  name: "\(impl.name)Tests",
  dependencies: [
    .target(name: impl.name),
    .target(name: tests.name)
  ]
)

package.targets = [service, impl, tests, mockTests, implTests]

// MARK: - (PRODUCTS)

package.products.append(.library(name: package.name, targets: [service.name, impl.name]))
