# 🌍 GeoJSON

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkiliankoe%2FGeoJSON%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/kiliankoe/GeoJSON)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkiliankoe%2FGeoJSON%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/kiliankoe/GeoJSON)

This is a Swift package for working with [GeoJSON](https://geojson.org) data. It contains necessary types conforming to `Codable` for easy de-/encoding of data.

The implementation of this package tries to follow the specification defined in [RFC 7946](https://tools.ietf.org/html/rfc7946) as closely as possible. One exception are [Foreign Members](https://tools.ietf.org/html/rfc7946#section-6.1), which - according to the spec - MAY be implemented, but are not supported at all by this package.

## Usage

You can give this package a quick spin by cloning the repository and running `swift run --repl` inside it.

### Encoding

Create a `FeatureCollection` or just a single `Feature` to create some GeoJSON data. 

```swift
let features = FeatureCollection(features: [
    Feature(
        geometry: .point(Point(longitude: 125.6, latitude: 10.1)),
        properties: [
            "name": "Dinagat Island"
        ]
    )
])

let json = try JSONEncoder().encode(features)
```

### Decoding

It works the same way in the other direction. Use a standard `JSONDecoder` to decode GeoJSON data into a fitting type.

```swift
let features = try JSONDecoder().decode(FeatureCollection.self, from: json)
```

## Installation

This package is available via Swift Package Manager, add its clone URL to your project to get started.
