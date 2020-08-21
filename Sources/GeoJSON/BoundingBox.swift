/// Information on the coordinate range for other GeoJSON objects. Contains two `Position`s which denote the most southwesterly and most northeasterly
/// points of the object's geometry.
/// See [RFC9746 Section 5](https://tools.ietf.org/html/rfc7946#section-5) for more information.
public struct BoundingBox: Equatable, Codable {
    public var southWesterly: Position
    public var northEasterly: Position

    public init(southWesterly: Position, northEasterly: Position) {
        self.southWesterly = southWesterly
        self.northEasterly = northEasterly
    }

    public enum Error: Swift.Error {
        /// A `BoundingBox` is expected to contain four or six values.
        case unexpectedValueCount
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        switch container.count {
        case 4:
            self.southWesterly = Position(longitude: try container.decode(Double.self),
                                          latitude: try container.decode(Double.self))
            self.northEasterly = Position(longitude: try container.decode(Double.self),
                                          latitude: try container.decode(Double.self))
        case 6:
            self.southWesterly = Position(longitude: try container.decode(Double.self),
                                          latitude: try container.decode(Double.self),
                                          altitude: try container.decode(Double.self))
            self.northEasterly = Position(longitude: try container.decode(Double.self),
                                          latitude: try container.decode(Double.self),
                                          altitude: try container.decode(Double.self))
        default:
            throw Error.unexpectedValueCount
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        // Altitude is only encoded if both `Positions`s include one. Otherwise the value count would be off.
        if southWesterly.altitude != nil && northEasterly.altitude != nil {
            try container.encode(southWesterly.longitude)
            try container.encode(southWesterly.latitude)
            try container.encode(southWesterly.altitude)
            try container.encode(northEasterly.longitude)
            try container.encode(northEasterly.latitude)
            try container.encode(northEasterly.altitude)
        } else {
            try container.encode(southWesterly.longitude)
            try container.encode(southWesterly.latitude)
            try container.encode(northEasterly.longitude)
            try container.encode(northEasterly.latitude)
        }
    }
}

// See [RFC7946 Section 5.3](https://tools.ietf.org/html/rfc7946#section-4).
extension BoundingBox {
    /// A bounding box that contains the North Pole. Viewed on a globe, this bounding box approximates a spherical cap bounded by the minimum latitude circle.
    public static func containsNorthPole(minimumLatitude: Double) -> BoundingBox {
        BoundingBox(southWesterly: .init(longitude: -180.0, latitude: minimumLatitude),
                    northEasterly: .init(longitude: 180.0, latitude: 90.0))
    }

    /// A bounding box that contains the South Pole.
    public static func containsSouthPole(maximumLatitude: Double) -> BoundingBox {
        BoundingBox(southWesterly: .init(longitude: -180.0, latitude: -90.0),
                    northEasterly: .init(longitude: 180.0, latitude: maximumLatitude))
    }

    /// A bounding box that just touches the North Pole and forms a slice of an approximate spherical cap when viewed on a globe.
    public static func touchesNorthPole(westLongitude: Double, minimumLatitude: Double, eastLongitude: Double)
    -> BoundingBox {
        BoundingBox(southWesterly: .init(longitude: westLongitude, latitude: minimumLatitude),
                    northEasterly: .init(longitude: eastLongitude, latitude: 90.0))
    }

    /// A bounding box that just touches the South Pole and forms a slice of an approximate spherical cap when viewed on a globe.
    public static func touchesSouthPole(westLongitude: Double, eastLongitude: Double, maximumLatitude: Double)
    -> BoundingBox {
        BoundingBox(southWesterly: .init(longitude: westLongitude, latitude: -90.0),
                    northEasterly: .init(longitude: eastLongitude, latitude: maximumLatitude))
    }
}
