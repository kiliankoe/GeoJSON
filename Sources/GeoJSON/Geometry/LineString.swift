/// A string of two or more `Position`s.
public struct LineString: Equatable, Codable {
    public var coordinates: [Position]

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
        let container = try decoder.singleValueContainer()
        self.coordinates = try container.decode([Position].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(coordinates)
    }
}
