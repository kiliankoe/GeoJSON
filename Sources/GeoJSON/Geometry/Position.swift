public struct Position: Equatable, Codable {
    public let longitude: Double
    public let latitude: Double

    public enum Error: Swift.Error {
        case unexpectedValueCount
    }

    public init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let values = try container.decode([Double].self)
        guard values.count == 2 else {
            throw Error.unexpectedValueCount
        }
        self.longitude = values[0]
        self.latitude = values[1]
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
    }
}

#if canImport(CoreLocation)
import CoreLocation

extension Position {
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    public init(from coordinate: CLLocationCoordinate2D) {
        self.longitude = coordinate.longitude
        self.latitude = coordinate.latitude
    }
}
#endif
