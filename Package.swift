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
  ],
  targets: [
    .target(
      name: "RemoteDatabaseService",
      dependencies: ["Queries"]
    ),
    .target(
      name: "CloudKitService",
      dependencies: ["RemoteDatabaseService", "Queries"]
    ),
    .testTarget(
      name: "RemoteDatabaseServiceTests",
      dependencies: ["RemoteDatabaseService", "CloudKitService", "Queries"],
      path: "Tests"
    )
  ]
)
