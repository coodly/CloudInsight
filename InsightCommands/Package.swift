// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InsightCommands",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.2.1"),
        .package(url: "https://github.com/coodly/TalkToCloud.git", from: "0.10.1"),
        .package(name: "SWLogger", url: "https://github.com/coodly/swlogger.git", from: "0.4.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Clean",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser"), "TalkToCloud", "SWLogger"]),
        .testTarget(
            name: "InsightCommandsTests",
            dependencies: ["Clean"]),
    ]
)
