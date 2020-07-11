/// Information on the coordinate range for other GeoJSON objects. Contains two `Position`s which denote the most southwesterly and most northeasterly points
/// of the object's geometry.
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
