public enum Geometry: Equatable, Codable {
    case point(Point)
    case multiPoint(MultiPoint)
    case lineString(LineString)
    case multiLineString(MultiLineString)
    case polygon(Polygon)
    case multiPolygon(MultiPolygon)

    public enum Error: Swift.Error {
        case unknownGeometryType
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "Point":
            self = .point(try container.decode(Point.self, forKey: .coordinates))
        case "MultiPoint":
            self = .multiPoint(try container.decode(MultiPoint.self, forKey: .coordinates))
        case "LineString":
            self = .lineString(try container.decode(LineString.self, forKey: .coordinates))
        case "MultiLineString":
            self = .multiLineString(try container.decode(MultiLineString.self, forKey: .coordinates))
        case "Polygon":
            self = .polygon(try container.decode(Polygon.self, forKey: .coordinates))
        case "MultiPolygon":
            self = .multiPolygon(try container.decode(MultiPolygon.self, forKey: .coordinates))
        default:
            throw Error.unknownGeometryType
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .point(let point):
            try container.encode("Point", forKey: .type)
            try container.encode(point, forKey: .coordinates)
        case .multiPoint(let multiPoint):
            try container.encode("MultiPoint", forKey: .type)
            try container.encode(multiPoint, forKey: .coordinates)
        case .lineString(let lineString):
            try container.encode("LineString", forKey: .type)
            try container.encode(lineString, forKey: .coordinates)
        case .multiLineString(let multiLineString):
            try container.encode("MutliLineString", forKey: .type)
            try container.encode(multiLineString, forKey: .coordinates)
        case .polygon(let polygon):
            try container.encode("Polygon", forKey: .type)
            try container.encode(polygon, forKey: .coordinates)
        case .multiPolygon(let multiPolygon):
            try container.encode("MultiPolygon", forKey: .type)
            try container.encode(multiPolygon, forKey: .coordinates)
        }
    }
}
