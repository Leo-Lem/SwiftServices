// swift-tools-version: 5.7

import PackageDescription

// MARK: - (TARGETS)

let service = Target.target(
  name: "IndexingService"
)

let implementation = Target.target(
  name: "CoreSpotlightService",
  dependencies: [
    .target(name: service.name),
    "Errors"
  ]
)

let serviceTests = Target.target(
  name: "\(service.name)Tests",
  dependencies: [
    .target(name: service.name),
    "Previews"
  ],
  path: "Tests/\(service.name)Tests"
)

let implementationTests = Target.testTarget(
  name: "\(implementation.name)Tests",
  dependencies: [
    .target(name: implementation.name),
    .target(name: serviceTests.name)
  ]
)

// MARK: - (PRODUCTS)

let library = Product.library(
  name: service.name,
  targets: [service.name, implementation.name]
)

// MARK: - (DEPENDENCIES)

let errors = Package.Dependency.package(url: "https://github.com/Leo-Lem/Errors", branch: "main"),
    previews = Package.Dependency.package(url: "https://github.com/Leo-Lem/Previews", branch: "main")

// MARK: - (PACKAGE)

let package = Package(
  name: library.name,
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [library],
  dependencies: [errors, previews],
  targets: [service, implementation, serviceTests, implementationTests]
)
