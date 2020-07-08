// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "GeoJSON",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
        .watchOS(.v4),
        .tvOS(.v11),
    ],
    products: [
        .library(
            name: "GeoJSON",
            targets: ["GeoJSON"]),
    ],
    dependencies: [
        .package(url: "https://github.com/flight-school/AnyCodable.git", from: "0.2.3"),
    ],
    targets: [
        .target(
            name: "GeoJSON",
            dependencies: ["AnyCodable"]),
        .testTarget(
            name: "GeoJSONTests",
            dependencies: ["GeoJSON"]),
    ]
)
