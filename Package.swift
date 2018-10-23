// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Disks",
    products: [
        .library(
            name: "Disks",
            targets: ["Disks"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        
        .package(url: "https://github.com/zdnk/S3.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "Disks",
            dependencies: ["Vapor", "S3"]
        ),
        .testTarget(
            name: "DisksTests",
            dependencies: [
                "Disks",
                "Vapor",
            ]
        ),
    ]
)
