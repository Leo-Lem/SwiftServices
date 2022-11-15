// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Key-Value Storage Service",
  products: [
    .library(
      name: "KeyValueStorageService",
      targets: [
        "KeyValueStorageService",
        "UserDefaultsStorageService"
      ]
    )
  ],
  dependencies: [],
  targets: [
    .target(name: "KeyValueStorageService"),
    .target(
      name: "UserDefaultsStorageService",
      dependencies: ["KeyValueStorageService"]
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
