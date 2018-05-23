// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Diff",
    products: [
        .library(
            name: "Diff",
            targets: ["Diff"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Diff",
            dependencies: []),
        .testTarget(
            name: "DiffTests",
            dependencies: ["Diff"]),
    ]
)
