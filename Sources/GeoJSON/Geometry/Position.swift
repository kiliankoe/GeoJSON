/// A fundamental geometry construct containing the coordinates of a geographic position and an optional altitude.
/// See [RFC9746 Section 3.1.1](https://tools.ietf.org/html/rfc7946#section-3.1.1) and
/// [Section 4](https://tools.ietf.org/html/rfc7946#section-4) for more information.
public struct Position: Equatable, Codable {
    public var longitude: Double
    public var latitude: Double
    /// Altitude or elevation in meters above or below the WGS 84 reference ellipsoid. If not set, this `Position` will be interpreted as being at local ground or
    /// sea level.
    public var altitude: Double?

    public enum Error: Swift.Error {
        /// A `Position` is expected to contain exactly two or three values.
        case unexpectedValueCount
    }

    public init(longitude: Double, latitude: Double, altitude: Double? = nil) {
        self.longitude = longitude
        self.latitude = latitude
        self.altitude = altitude
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        guard (container.count ?? 0) >= 2 else {
            throw Error.unexpectedValueCount
        }
        self.longitude = try container.decode(Double.self)
        self.latitude = try container.decode(Double.self)
        self.altitude = try container.decodeIfPresent(Double.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
        if let altitude = altitude {
            try container.encode(altitude)
        }
    }
}

#if canImport(Foundation)
import Foundation

extension Position {
    public var altitudeMeasurement: Measurement<UnitLength>? {
        altitude.flatMap { Measurement<UnitLength>(value: $0, unit: .meters) }
    }
}
#endif

#if canImport(CoreLocation)
import CoreLocation

extension Position {
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    public var location: CLLocation {
        if let altitude = altitude {
            // What should the default values for accuracy and timestamp be here? I only really want to pass the
            // altitude.
            return CLLocation(coordinate: coordinate,
                              altitude: altitude,
                              horizontalAccuracy: 0,
                              verticalAccuracy: 0,
                              timestamp: Date())
        }
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    public init(from coordinate: CLLocationCoordinate2D) {
        self.longitude = coordinate.longitude
        self.latitude = coordinate.latitude
    }

    public init(from location: CLLocation) {
        self.longitude = location.coordinate.longitude
        self.latitude = location.coordinate.latitude
        self.altitude = location.altitude
    }
}
#endif
