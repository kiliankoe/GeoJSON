public struct FeatureCollection: Equatable, Codable {
    let type = "FeatureCollection"
    public var features: [Feature]

    // This is defined explicitly to silence the warning about `type` having a static value above.
    private enum CodingKeys: CodingKey {
        case type
        case features
    }

    public init(features: [Feature]) {
        self.features = features
    }
}

public typealias Document = FeatureCollection
