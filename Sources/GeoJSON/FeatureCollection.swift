/// A collection of `Feature`s.
public struct FeatureCollection: Equatable, Codable {
    let type = "FeatureCollection"
    public var features: [Feature]
    public var boundingBox: BoundingBox?

    // This is defined explicitly to silence the warning about `type` having a static value above.
    private enum CodingKeys: String, CodingKey {
        case type
        case features
        case boundingBox = "bbox"
    }

    public init(features: [Feature], boundingBox: BoundingBox? = nil) {
        self.features = features
        self.boundingBox = boundingBox
    }
}
