// swift-vapor/Package.swift
// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "HowdySwift",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.100.0"),
        .package(url: "https://github.com/elementary-swift/elementary.git", from: "0.7.0")
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
