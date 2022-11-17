// swift-tools-version: 5.7

import PackageDescription

// MARK: - (TARGETS)

let service = Target.target(
  name: "RemoteDatabaseService",
  dependencies: ["Concurrency"]
)

let implementation = Target.target(
  name: "CloudKitService",
  dependencies: [
    .target(name: service.name),
    "Queries",
    "Concurrency",
    "Errors"
  ]
)

let serviceTests = Target.target(
  name: "\(service.name)Tests",
  dependencies: [
    .target(name: service.name),
    "Queries",
    "Concurrency"
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

let queries = Package.Dependency.package(url: "https://github.com/Leo-Lem/Queries", branch: "main"),
    concurrency = Package.Dependency.package(url: "https://github.com/Leo-Lem/Concurrency", branch: "main"),
    errors = Package.Dependency.package(url: "https://github.com/Leo-Lem/Errors", branch: "main")

// MARK: - (PACKAGE)

let package = Package(
  name: library.name,
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [library],
  dependencies: [queries, concurrency, errors],
  targets: [service, implementation, serviceTests, implementationTests]
)
