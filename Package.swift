// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftMessengerWrappers",
    products: [
        .library(name: "SwiftMessengerWrappers", targets: ["SwiftMessengerWrappers"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.1.0")),

        .package(url: "https://github.com/czechboy0/Jay.git", .upToNextMajor(from: "1.0.1")),
    ],
    targets: [
        .target(
            name: "SwiftMessengerWrappers",
            dependencies: ["Vapor", "Jay"]
        )
    ]
)

