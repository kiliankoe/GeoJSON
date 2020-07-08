import Foundation

public enum Geometry: Codable {
    case point(Point)
    case multiPoint(MultiPoint)
    case lineString(LineString)
    case multiLineString(MultiLineString)
    case polygon(Polygon)
    case multiPolygon(MultiPolygon)

    public init(from decoder: Decoder) throws {
        // TODO
        self = .point(Point(coordinates: Position(longitude: 1.0, latitude: 1.0)))
    }

    public func encode(to encoder: Encoder) throws {

    }
}
