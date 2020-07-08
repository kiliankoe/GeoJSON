import AnyCodable

public struct Feature: Equatable, Codable {
    let type = "Feature"
    public var geometry: Geometry?
    public var properties: Properties?

    // This is defined explicitly to silence the warning about `type` having a static value above.
    private enum CodingKeys: CodingKey {
        case type
        case geometry
        case properties
    }

    public init(geometry: Geometry?, properties: [String: AnyCodable]? = nil) {
        self.geometry = geometry
        self.properties = properties.flatMap { Properties(data: $0) }
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

extension Feature {
    @dynamicMemberLookup
    public struct Properties: Equatable, Codable {
        public let data: [String: AnyCodable]

        public subscript<T>(dynamicMember member: String) -> T? {
            guard let value = data[member] else { return nil }
            return value.value as? T
        }

        public subscript(key: String) -> AnyCodable? {
            data[key]
        }

        init(data: [String: AnyCodable]) {
            self.data = data
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            data = try container.decode([String: AnyCodable].self)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(data)
        }
    }
}
