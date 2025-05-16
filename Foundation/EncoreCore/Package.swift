// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EncoreCore",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "EncoreCore", targets: ["EncoreCore", "EncoreCoreBridge"])
    ],
    dependencies: [
        .package(url: "https://github.com/rrk567301/SPMDiscordRPC.git", branch: "main"),
        .package(url: "https://github.com/rrk567301/SPMSPTPersistentCache.git", branch: "main")
    ],
    targets: [
        .target(name: "EncoreCore", dependencies: ["SPMDiscordRPC", "SPMSPTPersistentCache"], publicHeadersPath: "include"),
        .target(name: "EncoreCoreBridge", dependencies: ["EncoreCore"])
    ]
)
