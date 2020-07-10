/// A collection of `LineString`s, each containing two or more `Position`s.
public struct MultiLineString: Equatable, Codable {
    public var coordinates: [LineString]

    public init(coordinates: [LineString]) {
        self.coordinates = coordinates
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.coordinates = try container.decode([LineString].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(coordinates)
    }
}
