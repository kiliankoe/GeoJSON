// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "GeoJSON",
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
