// swift-tools-version: 5.7

import PackageDescription

// MARK: - (TARGETS)

let service = Target.target(
  name: "AuthenticationService",
  dependencies: ["LeosMisc"],
  resources: [.process("ui/res")]
)

let implementation = Target.target(
  name: "MyAuthenticationService",
  dependencies: [
    .target(name: service.name),
    "KeyValueStorageService"
  ]
)

let serviceTests = Target.target(
  name: "\(service.name)Tests",
  dependencies: [
    .target(name: service.name),
    "KeyValueStorageService"
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

let kvss = Package.Dependency.package(url: "https://github.com/Leo-Lem/KeyValueStorageService", branch: "main")
let misc = Package.Dependency.package(url: "https://github.com/Leo-Lem/LeosMisc", branch: "main")

// MARK: - (PACKAGE)

let package = Package(
  name: library.name,
  defaultLocalization: "en",
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [library],
  dependencies: [kvss, misc],
  targets: [service, implementation, serviceTests, implementationTests]
)
