public struct MultiLineString: Codable {
    public let coordinates: [LineString]

    public init(coordinates: [LineString]) {
        self.coordinates = coordinates
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.coordinates = try container.decode([LineString].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(coordinates)
    }
}
