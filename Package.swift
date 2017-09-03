// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Rupert",
    products: [
        .library(
            name: "Rupert",
            targets: ["Rupert"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Rupert",
            dependencies: []),
        .testTarget(
            name: "RupertTests",
            dependencies: ["Rupert"]),
    ]
)
