import AnyCodable

public struct Feature: Codable {
    public let geometry: Geometry
    public let properties: [String: AnyCodable]
}
