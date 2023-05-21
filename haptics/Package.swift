// swift-tools-version: 5.7

import PackageDescription

// MARK: - (TARGETS)

let service = Target.target(
  name: "HapticsService"
)

let implementation = Target.target(
  name: "CoreHapticsService",
  dependencies: [
    .target(name: service.name),
    "Errors"
  ]
)

// MARK: - (PRODUCTS)

let library = Product.library(
  name: service.name,
  targets: [service.name, implementation.name]
)

// MARK: - (DEPENDENCIES)

let dependency = Package.Dependency.package(url: "https://github.com/Leo-Lem/Errors", branch: "main")

// MARK: - (PACKAGE)

let package = Package(
  name: library.name,
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [library],
  dependencies: [dependency],
  targets: [service, implementation]
)
