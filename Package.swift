// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Key-Value Storage Service",
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [
    .library(
      name: "KeyValueStorageService",
      targets: [
        "KeyValueStorageService",
        "UserDefaultsStorageService"
      ]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/Leo-Lem/Concurrency", branch: "main")
  ],
  targets: [
    .target(name: "KeyValueStorageService"),
    .target(
      name: "UserDefaultsStorageService",
      dependencies: ["KeyValueStorageService", "Concurrency"]
    ),
    .testTarget(
      name: "KeyValueStorageServiceTests",
      dependencies: [
        "KeyValueStorageService",
        "UserDefaultsStorageService"
      ],
      path: "Tests"
    )
  ]
)
