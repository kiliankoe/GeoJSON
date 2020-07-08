public struct Point: Codable {
    public let coordinates: Position

    public init(coordinates: Position) {
        self.coordinates = coordinates
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.coordinates = try container.decode(Position.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(coordinates)
    }
}
