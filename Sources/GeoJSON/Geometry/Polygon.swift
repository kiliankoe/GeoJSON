/// A collection of `LinearRing`s. The first ring is expected to be the exterior ring, any others are interior rings. The exterior ring bounds the surface, and the
/// interior rings (if present) bound holes within the surface.
public struct Polygon: Equatable, Codable {
    public var coordinates: [LinearRing]

    public init(coordinates: [LinearRing]) {
        self.coordinates = coordinates
    }

    public init(coordinates: [[Position]]) throws {
        self.coordinates = try coordinates.map { try LinearRing(coordinates: $0) }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.coordinates = try container.decode([LinearRing].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(coordinates)
    }
}

extension Polygon {
    /// A closed `LineString` containing four or more `Position`s. The first and last value are expected to be the same so that the ring is closed. A linear
    /// ring is the boundary of a surface or the boundary of a hole in a surface and must follow the right-hand rule with respect to the area it bounds, i.e. exterior
    /// rings are counterclockwise, and holes are clockwise.
    public struct LinearRing: Equatable, Codable {
        public let coordinates: [Position]

        public enum Error: Swift.Error {
            /// A LinearRing consists of four or more positions.
            case invalidCoordinateCount
            /// The first and last position in a LinearRing must be identical.
            case openRing
        }

        /// - Throws: `LinearRing.Error`
        public init(coordinates: [Position]) throws {
            guard coordinates.count >= 4 else { throw Error.invalidCoordinateCount }
            guard coordinates.first == coordinates.last else { throw Error.openRing }

            self.coordinates = coordinates
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.coordinates = try container.decode([Position].self)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(coordinates)
        }
    }
}
