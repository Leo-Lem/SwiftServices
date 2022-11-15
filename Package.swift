// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Remote Database Service",
  platforms: [.iOS(.v15), .macOS(.v12)],
  products: [
    .library(
      name: "RemoteDatabaseService",
      targets: ["RemoteDatabaseService", "CloudKitService"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/Leo-Lem/Queries", branch: "main"),
    .package(url: "https://github.com/Leo-Lem/Concurrency", branch: "main"),
    .package(url: "https://github.com/Leo-Lem/Errors", branch: "main")
  ],
  targets: [
    .target(
      name: "RemoteDatabaseService",
      dependencies: ["Queries", "Concurrency"]
    ),
    .target(
      name: "CloudKitService",
      dependencies: ["RemoteDatabaseService", "Queries", "Concurrency", "Errors"]
    ),
    .testTarget(
      name: "RemoteDatabaseServiceTests",
      dependencies: ["RemoteDatabaseService", "CloudKitService", "Queries", "Concurrency"],
      path: "Tests"
    )
  ]
)
