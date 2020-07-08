import AnyCodable

public struct Feature: Equatable, Codable {
    public let geometry: Geometry
    public let properties: [String: AnyCodable]
}
