// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "DitoSDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "DitoSDK",
            targets: ["DitoSDK"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DitoSDK",
            path: "Source",
            dependencies: []
        ),
        .testTarget(
            name: "DitoSDKTests",
            dependencies: ["DitoSDK"],
            path: "Tests"
        ),
    ]
)
