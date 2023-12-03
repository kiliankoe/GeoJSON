# 🌍 GeoJSON

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkiliankoe%2FGeoJSON%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/kiliankoe/GeoJSON)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkiliankoe%2FGeoJSON%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/kiliankoe/GeoJSON)

This is a Swift package for working with [GeoJSON](https://geojson.org) data. It contains necessary types conforming to `Codable` for easy de-/encoding of data.

The implementation of this package aims to follow the specification defined in [RFC 7946](https://tools.ietf.org/html/rfc7946).

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

If you don't know if the data to decode is a `Feature` or `FeatureCollection`, decode a value of type `GeoJSONDocument`, which handles 
both.

```swift
let document = try JSONDecoder().decode(GeoJSONDocument.self, from: json)
switch document {
case .feature(let feature):
    // ...
case .featureCollection(let featureCollection):
    // ...
}
```

## Installation

This package is available via Swift Package Manager, add its clone URL to your project to get started.

## Documentation

Documentation of this package is provided via a [DocC](https://www.swift.org/documentation/docc/) documentation catalog.

The official specification of [RFC 7946](https://tools.ietf.org/html/rfc7946) is the best source of documentation about GeoJSON itself.

### Building the documentation

To build the documentation from the command-line:

```
$ swift package generate-documentation
```

Add the `--help` flag to get a list of all supported arguments and options.

### Xcode

You can also build the documentation directly in [Xcode](https://developer.apple.com/xcode/) from the Product menu:

**Product > Build Documentation**

The documentation can then be viewed in the documentation viewer.

