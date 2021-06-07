public enum Geometry: Equatable, Codable {
    /// A single point, containing only the coordinates of a `Position`.
    case point(Point)
    /// Several `Position`s.
    case multiPoint(MultiPoint)
    /// A string of two or more `Position`s.
    case lineString(LineString)
    /// A collection of `LineString`s, each containing two or more `Position`s.
    case multiLineString(MultiLineString)
    /// A collection of `LinearRing`s. The first ring is expected to be the exterior ring, any others are interior rings. The exterior ring bounds the surface, and the
    /// interior rings (if present) bound holes within the surface.
    case polygon(Polygon)
    /// A collection of `Polygon`s.
    case multiPolygon(MultiPolygon)
    /// A heterogeneous composition of other `Geometry` objects. For example, a `Geometry` object in the shape of a lowercase roman "i" can be composed
    /// of one `Point` and one `LineString`. Please try and avoid nested `GeometryCollection`s to maximize interopability.
    /// See [RFC7946 Section 3.1.8](https://tools.ietf.org/html/rfc7946#section-3.1.8) for more information.
    case geometryCollection(GeometryCollection)

    public enum Error: Swift.Error {
        case unknownGeometryType
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case coordinates
        case geometries
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
        case "GeometryCollection":
            self = .geometryCollection(try container.decode(GeometryCollection.self, forKey: .geometries))
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
            try container.encode("MultiLineString", forKey: .type)
            try container.encode(multiLineString, forKey: .coordinates)
        case .polygon(let polygon):
            try container.encode("Polygon", forKey: .type)
            try container.encode(polygon, forKey: .coordinates)
        case .multiPolygon(let multiPolygon):
            try container.encode("MultiPolygon", forKey: .type)
            try container.encode(multiPolygon, forKey: .coordinates)
        case .geometryCollection(let geometryCollection):
            try container.encode("GeometryCollection", forKey: .type)
            try container.encode(geometryCollection, forKey: .geometries)
        }
    }
}
