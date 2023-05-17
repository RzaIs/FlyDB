// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FlyDB",
    products: [
        .library(
            name: "FlyDB",
            targets: ["FlyDB"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CoreDB"
        ),
        .target(
            name: "FlyDB",
            dependencies: ["CoreDB"]
        ),
        .testTarget(
            name: "FlyDBTests",
            dependencies: ["FlyDB"]
        ),
    ]
)
