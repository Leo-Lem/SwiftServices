// swift-tools-version: 5.7

import PackageDescription

// MARK: - (TARGETS)

let service = Target.target(
  name: "KeyValueStorageService"
)

let implementation = Target.target(
  name: "UserDefaultsService",
  dependencies: [.target(name: service.name), "Concurrency"]
)

let baseTests = Target.target(
  name: "BaseTests",
  dependencies: [.target(name: service.name)],
  path: "Tests/BaseTests"
)

let mockTests = Target.testTarget(
  name: "Mock\(service.name)Tests",
  dependencies: [.target(name: baseTests.name)]
)

let implementationTests = Target.testTarget(
  name: "\(implementation.name)Tests",
  dependencies: [
    .target(name: implementation.name),
    .target(name: baseTests.name)
  ]
)

// MARK: - (PRODUCTS)

let library = Product.library(
  name: service.name,
  targets: [service.name, implementation.name]
)

// MARK: - (DEPENDENCIES)

let dependency = Package.Dependency.package(url: "https://github.com/Leo-Lem/Concurrency", branch: "main")

// MARK: - (PACKAGE)

let package = Package(
  name: library.name,
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [library],
  dependencies: [dependency],
  targets: [service, implementation, baseTests, mockTests, implementationTests]
)
