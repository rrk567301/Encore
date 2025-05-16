// swift-tools-version: 5.5

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
        .package(url: "https://github.com/getencore/SPMDiscordRPC.git", branch: "main"),
        .package(url: "https://github.com/getencore/SPMSPTPersistentCache.git", .upToNextMajor(from: "1.1.2")),
        .package(url: "https://github.com/getencore/SPMxxHash.git", .upToNextMajor(from: "0.8.3"))
    ],
    targets: [
        .target(name: "EncoreCore", dependencies: ["SPMDiscordRPC", "SPMSPTPersistentCache", "SPMxxHash"], publicHeadersPath: "include"),
        .target(name: "EncoreCoreBridge", dependencies: ["EncoreCore"])
    ]
)
