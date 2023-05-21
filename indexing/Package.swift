// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "IndexingService",
  platforms: [.iOS(.v13), .macOS(.v10_15)]
)

// MARK: - (DEPENDENCIES)

let errors = "Errors"
let previews = "Previews"

for name in [errors, previews] {
  package.dependencies.append(.package(url: "https://github.com/Leo-Lem/\(name)", branch: "main"))
}

// MARK: - (TARGETS)

let service = Target.target(name: "IndexingService")

let impl = Target.target(
  name: "CoreSpotlightService",
  dependencies: [
    .target(name: service.name),
    .byName(name: errors)
  ]
)

let tests = Target.target(
  name: "BaseTests",
  dependencies: [
    .target(name: service.name),
    .byName(name: previews)
  ],
  path: "Tests/BaseTests"
)

let implementationTests = Target.testTarget(
  name: "\(impl.name)Tests",
  dependencies: [
    .target(name: impl.name),
    .target(name: tests.name)
  ]
)

package.targets = [service, impl, tests, implementationTests]

// MARK: - (PRODUCTS)

package.products.append(.library(name: package.name, targets: [service.name, impl.name]))
