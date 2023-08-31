// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "CCMNetwork",
    defaultLocalization: "pt-BR",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CCMNetwork",
            targets: ["CCMNetwork"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CCMNetwork",
            dependencies: []
        ),
        .testTarget(
            name: "CCMNetworkTests",
            dependencies: ["CCMNetwork"]
        ),
    ]
)
