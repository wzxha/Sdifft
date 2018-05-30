// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sdifft",
    products: [
        .library(
            name: "Sdifft",
            targets: ["Sdifft"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Sdifft",
            dependencies: []),
        .testTarget(
            name: "SdifftTests",
            dependencies: ["Sdifft"])
    ]
)
