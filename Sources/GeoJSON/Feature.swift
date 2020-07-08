import AnyCodable

public struct Feature: Equatable, Codable {
    let type = "Feature"
    public let geometry: Geometry
    public let properties: [String: AnyCodable]

    public init(geometry: Geometry, properties: [String: AnyCodable] = [:]) {
        self.geometry = geometry
        self.properties = properties
    }
}
