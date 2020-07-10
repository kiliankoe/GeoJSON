/// A single point, containing only the coordinates of a `Position`.
public struct Point: Equatable, Codable {
    public var coordinates: Position

    public init(coordinates: Position) {
        self.coordinates = coordinates
    }

    public init(longitude: Double, latitude: Double, altitude: Double? = nil) {
        self.coordinates = Position(longitude: longitude, latitude: latitude, altitude: altitude)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.coordinates = try container.decode(Position.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(coordinates)
    }
}
