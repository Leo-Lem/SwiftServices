// swift-tools-version: 5.7

import PackageDescription

// MARK: - (TARGETS)

let service = Target.target(
  name: "InAppPurchaseService",
  dependencies: [
    "Previews"
  ]
)

let implementation = Target.target(
  name: "StoreKitService",
  dependencies: [
    .target(name: service.name),
    "Concurrency",
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

let concurrency = Package.Dependency.package(url: "https://github.com/Leo-Lem/Concurrency.git", branch: "main")
let errors = Package.Dependency.package(url: "https://github.com/Leo-Lem/Errors.git", branch: "main")
let previews = Package.Dependency.package(url: "https://github.com/Leo-Lem/Previews.git", branch: "main")

// MARK: - (PACKAGE)

let package = Package(
  name: library.name,
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [library],
  dependencies: [concurrency, errors, previews],
  targets: [service, implementation, serviceTests, implementationTests]
)
