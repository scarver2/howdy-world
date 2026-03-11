// swift-vapor/Package.swift
// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "HowdySwift",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.121.3"),
        .package(url: "https://github.com/elementary-swift/elementary.git", from: "0.6.4")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Elementary", package: "elementary")
            ],
            path: "Sources"
        )
    ]
)
