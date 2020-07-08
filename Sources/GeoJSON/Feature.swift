import AnyCodable

public struct Feature: Equatable, Codable {
    let type = "Feature"
    public var geometry: Geometry?
    public var properties: [String: AnyCodable]?

    // This is defined explicitly to silence the warning about `type` having a static value above.
    private enum CodingKeys: CodingKey {
        case type
        case geometry
        case properties
    }

    public init(geometry: Geometry?, properties: [String: AnyCodable]? = nil) {
        self.geometry = geometry
        self.properties = properties
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        if let geometry = geometry {
            try container.encode(geometry, forKey: .geometry)
        } else {
            try container.encodeNil(forKey: .geometry)
        }
        if let properties = properties {
            try container.encode(properties, forKey: .properties)
        } else {
            try container.encodeNil(forKey: .properties)
        }
    }
}
