/// A collection of `Polygon`s.
public struct MultiPolygon: Equatable, Codable {
    public var coordinates: [Polygon]

    public init(coordinates: [Polygon]) {
        self.coordinates = coordinates
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.coordinates = try container.decode([Polygon].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(coordinates)
    }
}
