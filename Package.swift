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
        
        .package(url: "https://github.com/zdnk/S3.git", .branch("s3-copy-file")),
//        .package(path: "../S3"),
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
