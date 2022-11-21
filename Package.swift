// swift-tools-version: 5.7

import PackageDescription

// MARK: - (TARGETS)

let service = Target.target(
  name: "AuthenticationService",
  dependencies: ["LeosMisc"],
  resources: [.process("res")]
)

let implementation = Target.target(
  name: "LLAuthenticationService",
  dependencies: [
    .target(name: service.name)
  ]
)

let serviceTests = Target.target(
  name: "\(service.name)Tests",
  dependencies: [
    .target(name: service.name)
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

let misc = Package.Dependency.package(url: "https://github.com/Leo-Lem/LeosMisc", branch: "main")

// MARK: - (PACKAGE)

let package = Package(
  name: library.name,
  defaultLocalization: "en",
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [library],
  dependencies: [misc],
  targets: [service, implementation, serviceTests, implementationTests]
)
