public struct Polygon: Equatable, Codable {
    public let coordinates: [LinearRing]

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
            var container = try decoder.unkeyedContainer()
            self.coordinates = try container.decode([Position].self)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(coordinates)
        }
    }
}
