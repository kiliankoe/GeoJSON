public struct FeatureCollection: Equatable, Codable {
    let type = "FeatureCollection"
    public let features: [Feature]

    public init(features: [Feature]) {
        self.features = features
    }
}

public typealias Document = FeatureCollection
