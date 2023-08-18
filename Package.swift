// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FlyDB",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "FlyDB",
            targets: ["FlyDB"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FlyDB",
            dependencies: []
        ),
        .testTarget(
            name: "FlyDBTests",
            dependencies: ["FlyDB"]
        ),
    ]
)
