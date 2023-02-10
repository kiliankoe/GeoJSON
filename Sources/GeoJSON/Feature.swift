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
    public var boundingBox: BoundingBox?

    // This is defined explicitly to silence the warning about `type` having a static value above.
    private enum CodingKeys: String, CodingKey {
        case type
        case geometry
        case id
        case properties
        case boundingBox = "bbox"
    }

    /// - Parameters:
    ///   - geometry: A `Geometry` object or `nil` if the `Feature` is unlocated.
    ///   - id: If a `Feature` has a commonly used identifier, this should be included.
    ///   - properties: Any additional properties that should be included with the `Feature`.
    public init(geometry: Geometry?,
                id: String? = nil,
                properties: [String: AnyCodable]? = nil,
                boundingBox: BoundingBox? = nil) {
        self.geometry = geometry
        self.id = id
        self.properties = properties.flatMap { Properties(data: $0) }
        self.boundingBox = boundingBox
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        geometry = try container.decodeIfPresent(Geometry.self, forKey: .geometry)
        if let id = try? container.decodeIfPresent(String.self, forKey: .id) {
            self.id = id
        } else if let id = try container.decodeIfPresent(Double.self, forKey: .id) {
            self.id = String(id)
        }
        let properties = try container.decodeIfPresent([String: AnyCodable].self, forKey: .properties)
        self.properties = properties.flatMap { Properties(data: $0) }
        self.boundingBox = try container.decodeIfPresent(BoundingBox.self, forKey: .boundingBox)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        if let geometry = geometry {
            try container.encode(geometry, forKey: .geometry)
        } else {
            try container.encodeNil(forKey: .geometry)
        }
        try container.encodeIfPresent(id, forKey: .id)
        if let properties = properties {
            try container.encode(properties, forKey: .properties)
        } else {
            try container.encodeNil(forKey: .properties)
        }
        try container.encodeIfPresent(boundingBox, forKey: .boundingBox)
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
