public struct LineString: Codable {
    public let coordinates: [Position]

    public enum Error: Swift.Error {
        /// A LineString consists of two or more positions.
        case invalidCoordinateCount
    }

    /// - Throws: `LineString.Error`
    public init(coordinates: [Position]) throws {
        guard coordinates.count >= 2 else { throw Error.invalidCoordinateCount }

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
