// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "RemoteDatabaseService",
  platforms: [.iOS(.v15), .macOS(.v12)],
  products: [
    .library(
      name: "RemoteDatabaseService",
      targets: ["RemoteDatabaseService", "CloudKitService"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/Leo-Lem/Queries", branch: "main"),
    .package(url: "https://github.com/Leo-Lem/ExtendedConcurrency", branch: "main"),
  ],
  targets: [
    .target(
      name: "RemoteDatabaseService",
      dependencies: ["Queries", "ExtendedConcurrency"]
    ),
    .target(
      name: "CloudKitService",
      dependencies: ["RemoteDatabaseService", "Queries", "ExtendedConcurrency"]
    ),
    .testTarget(
      name: "RemoteDatabaseServiceTests",
      dependencies: ["RemoteDatabaseService", "CloudKitService", "Queries", "ExtendedConcurrency"],
      path: "Tests"
    )
  ]
)
