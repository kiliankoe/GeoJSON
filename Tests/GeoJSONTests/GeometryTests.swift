import XCTest
import GeoJSON

final class GeometryTests: XCTestCase {
    // MARK: - Decoding

    func testDecodePositions() throws {
        let p1 = try JSONDecoder().decode(Position.self, from: "[1,1]".data(using: .utf8)!)
        XCTAssertEqual(p1.longitude, 1.0)
        XCTAssertEqual(p1.latitude, 1.0)
        XCTAssertNil(p1.altitude)

        let p2 = try JSONDecoder().decode(Position.self, from: "[10.1,105.5,-20]".data(using: .utf8)!)
        XCTAssertEqual(p2.longitude, 10.1)
        XCTAssertEqual(p2.latitude, 105.5)
        XCTAssertEqual(p2.altitude, -20)
        XCTAssertEqual(p2.altitudeMeasurement, Measurement<UnitLength>(value: -20, unit: .meters))
    }

    func testDecodeGeometryCollection() throws {
        let json = """
        {
          "type" : "GeometryCollection",
          "geometries" : [
            {
              "coordinates" : [
                1,
                1
              ],
              "type" : "Point"
            },
            {
              "coordinates" : [
                [
                  2,
                  2
                ]
              ],
              "type" : "MultiPoint"
            }
          ]
        }
        """.data(using: .utf8)!

        let geoCollection = try JSONDecoder().decode(Geometry.self, from: json)
        guard case let .geometryCollection(geoCol) = geoCollection else { XCTFail(); return }
        XCTAssertEqual(geoCol.count, 2)
    }

    // MARK: - Encoding

    func testEncodePosition() throws {
        let p1 = Position(longitude: 1.0, latitude: 1.0)
        XCTAssertEqual(try jsonRepr(p1, pretty: false), "[1,1]")

        let p2 = Position(longitude: 2.0, latitude: 2.0, altitude: 2.0)
        XCTAssertEqual(try jsonRepr(p2, pretty: false), "[2,2,2]")
    }

    func testEncodePoint() throws {
        let p1 = Point(coordinates: Position(longitude: 1.0, latitude: 1.0))
        XCTAssertEqual(try jsonRepr(p1, pretty: false), "[1,1]")

        let p2 = Point(longitude: 2.0, latitude: 2.0, altitude: 2.0)
        XCTAssertEqual(try jsonRepr(p2, pretty: false), "[2,2,2]")
    }

    func testEncodeMultiPoint() throws {
        let mp = MultiPoint(coordinates: [
            Position(longitude: 1.0, latitude: 1.0)
        ])
        XCTAssertEqual(try jsonRepr(mp, pretty: false), "[[1,1]]")
    }

    func testEncodeLineString() throws {
        let ls = try LineString(coordinates: [
            Position(longitude: 1.0, latitude: 1.0),
            Position(longitude: 2.0, latitude: 2.0)
        ])
        XCTAssertEqual(try jsonRepr(ls, pretty: false), "[[1,1],[2,2]]")
    }

    func testEncodeMultiLineString() throws {
        let mls = try MultiLineString(coordinates: [
            LineString(coordinates: [
                Position(longitude: 1.0, latitude: 1.0),
                Position(longitude: 2.0, latitude: 2.0)
            ])
        ])
        XCTAssertEqual(try jsonRepr(mls, pretty: false), "[[[1,1],[2,2]]]")
    }

    func testEncodePolygon() throws {
        let p = try Polygon(coordinates: [
            [
                Position(longitude: 1.0, latitude: 1.0),
                Position(longitude: 2.0, latitude: 2.0),
                Position(longitude: 3.0, latitude: 3.0),
                Position(longitude: 1.0, latitude: 1.0)
            ]
        ])
        XCTAssertEqual(try jsonRepr(p, pretty: false), "[[[1,1],[2,2],[3,3],[1,1]]]")
    }

    func testEncodeMultiPolygon() throws {
        let mp = MultiPolygon(coordinates: [
            try Polygon(coordinates: [[
                Position(longitude: 1.0, latitude: 1.0),
                Position(longitude: 2.0, latitude: 2.0),
                Position(longitude: 3.0, latitude: 3.0),
                Position(longitude: 1.0, latitude: 1.0)
            ]])
        ])
        XCTAssertEqual(try jsonRepr(mp, pretty: false), "[[[[1,1],[2,2],[3,3],[1,1]]]]")
    }

    func testEncodeGeometry() throws {
        let geoPoint = Geometry.point(Point(coordinates: Position(longitude: 1.0, latitude: 1.0)))
        XCTAssertEqual(try jsonRepr(geoPoint), """
        {
          "coordinates" : [
            1,
            1
          ],
          "type" : "Point"
        }
        """)
    }

    func testEncodeGeometryCollection() throws {
        let geoCollection = Geometry.geometryCollection([
            .point(Point(longitude: 1.0, latitude: 1.0)),
            .multiPoint(MultiPoint(coordinates: [Position(longitude: 2.0, latitude: 2.0)]))
        ])
        XCTAssertEqual(try jsonRepr(geoCollection), """
        {
          "geometries" : [
            {
              "coordinates" : [
                1,
                1
              ],
              "type" : "Point"
            },
            {
              "coordinates" : [
                [
                  2,
                  2
                ]
              ],
              "type" : "MultiPoint"
            }
          ],
          "type" : "GeometryCollection"
        }
        """)
    }
}
