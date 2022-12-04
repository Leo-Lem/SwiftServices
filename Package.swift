// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "InAppPurchaseService",
  defaultLocalization: "en",
  platforms: [.iOS(.v13), .macOS(.v10_15)]
)

// MARK: - (DEPENDENCIES)

let mine = (
  concurrency: "Concurrency",
  errors: "Errors",
  previews: "Previews",
  misc: "LeosMisc"
)

for name in [mine.concurrency, mine.errors, mine.previews, mine.misc] {
  package.dependencies.append(.package(url: "https://github.com/Leo-Lem/\(name)", branch: "main"))
}

// MARK: - (TARGETS)

let service = Target.target(
  name: "InAppPurchaseService",
  dependencies: [
    .byName(name: mine.concurrency),
    .byName(name: mine.previews)
  ]
)

let ui = Target.target(
  name: "InAppPurchaseUI",
  dependencies: [
    .byName(name: mine.previews),
    .byName(name: mine.misc),
    .byName(name: mine.errors)
  ],
  resources: [.process("res")]
)

let impl = Target.target(
  name: "StoreKitService",
  dependencies: [
    .target(name: service.name),
    .byName(name: mine.concurrency),
    .byName(name: mine.errors)
  ]
)

let tests = Target.target(
  name: "BaseTests",
  dependencies: [.target(name: service.name)],
  path: "Tests/BaseTests"
)

let mockAndAnyTests = Target.testTarget(
  name: "MockAndAny\(service.name)Tests",
  dependencies: [.target(name: tests.name)]
)

let implTests = Target.testTarget(
  name: "\(impl.name)Tests",
  dependencies: [
    .target(name: tests.name),
    .target(name: impl.name)
  ]
)

package.targets = [service, ui, impl, tests, mockAndAnyTests, implTests]

// MARK: - (PRODUCTS)

package.products.append(.library(name: package.name, targets: [service.name, ui.name, impl.name]))
