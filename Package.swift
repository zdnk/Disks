// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "VaporFilesystem",
    products: [
        .library(
            name: "VaporFilesystem",
            targets: ["VaporFilesystem"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        
        .package(url: "https://github.com/LiveUI/S3.git", from: "3.0.0-RC3.1"),
    ],
    targets: [
        .target(
            name: "VaporFilesystem",
            dependencies: ["Vapor", "S3"]
        ),
        .testTarget(
            name: "VaporFilesystemTests",
            dependencies: [
                "VaporFilesystem",
                "Vapor",
            ]
        ),
    ]
)
