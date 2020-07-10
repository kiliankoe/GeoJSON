import AnyCodable

/// A `Feature` represents a spatially bounded "thing" which is represented by its geometry (or missing it if it is unlocated).
public struct Feature: Equatable, Codable {
    let type = "Feature"
    public var geometry: Geometry?
    /// A commonly used identifier, if known.
    /// - Warning: While IDs can be numbers according to the [specification](https://tools.ietf.org/html/rfc7946#section-3.2), they are always decoded as
    ///            `String`s if present.
    public var id: String?
    public var properties: Properties?

    // This is defined explicitly to silence the warning about `type` having a static value above.
    private enum CodingKeys: CodingKey {
        case type
        case geometry
        case id
        case properties
    }

    /// - Parameters:
    ///   - geometry: A `Geometry` object or `nil` if the `Feature` is unlocated.
    ///   - id: If a `Feature` has a commonly used identifier, this should be included.
    ///   - properties: Any additional properties that should be included with the `Feature`.
    public init(geometry: Geometry?, id: String? = nil, properties: [String: AnyCodable]? = nil) {
        self.geometry = geometry
        self.id = id
        self.properties = properties.flatMap { Properties(data: $0) }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        geometry = try container.decode(Geometry.self, forKey: .geometry)
        if let id = try? container.decodeIfPresent(String.self, forKey: .id) {
            self.id = id
        } else if let id = try container.decodeIfPresent(Double.self, forKey: .id) {
            self.id = String(id)
        }
        let properties = try container.decodeIfPresent([String: AnyCodable].self, forKey: .properties)
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
        if let id = id {
            try container.encode(id, forKey: .id)
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

        public subscript<T>(key: String) -> T? {
            guard let value = data[key] else { return nil }
            return value.value as? T
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
