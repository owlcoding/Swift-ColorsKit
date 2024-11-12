// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
// MIT License - See LICENSE file for details

import PackageDescription

let package = Package(
    name: "ColorsKit",
    platforms: [
        .iOS(.v14), .macOS(.v14), .watchOS(.v7), .tvOS(.v14), .visionOS(.v1),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Swift-ColorExtensions",
            targets: ["ColorExtensions"]),
        .library(
            name: "Swift-ColorPalettes",
            targets: ["ColorPalettes"]),
        .library(
            name: "ColorsKit",
            targets: ["ColorsKit"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ColorsKit",
            dependencies: ["ColorExtensions", "ColorPalettes"]
        ),
        .target(
            name: "ColorExtensions",
            path: "Sources/Color-Extensions"),
        .target(
            name: "ColorPalettes",
            dependencies: ["ColorExtensions"],
            path: "Sources/Color-Palettes"
        ),
        .testTarget(
            name: "ColorsKitTests",
            dependencies: ["ColorsKit"]
        ),
    ]
)
