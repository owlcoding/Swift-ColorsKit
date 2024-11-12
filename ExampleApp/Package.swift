// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ColorsKitExampleApp",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "ColorsKit_ExampleApp", type: .static, targets: ["ColorsKit_ExampleAppTarget"]),
        .executable(name: "ColorsKit_ExampleApplication", targets: ["ColorsKit_ExecutableTarget"]),
    ],
    dependencies: [
        .package(name: "ColorsKit", path: "../../Swift-ColorsKit"),
    ],
    
    targets: [
        .target(name: "ColorsKit_ExampleAppTarget",
               dependencies: ["ColorsKit"],
                path: "ColorPalettesExample/ColorPalettesExample"
               ),
        .executableTarget(name: "ColorsKit_ExecutableTarget",
                dependencies: ["ColorsKit"],
                path: "ColorPalettesExample/ExecutableTarget"
               ),
    ]
)
