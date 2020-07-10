import XCTest
import GeoJSON

final class DecodingTests: XCTestCase {
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

    func testDecodeHomepageExample() throws {
        let json = """
        {
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": [125.6, 10.1]
          },
          "properties": {
            "name": "Dinagat Islands"
          }
        }
        """.data(using: .utf8)!

        let geoJson = try JSONDecoder().decode(Feature.self, from: json)
        XCTAssertEqual(geoJson.geometry, .point(Point(longitude: 125.6, latitude: 10.1)))
        XCTAssertEqual(geoJson.properties?["name"], "Dinagat Islands")
        XCTAssertEqual(geoJson.properties?.name, "Dinagat Islands")
    }

    func testDecodeSpecExample() throws {
        let json = """
        {
            "type": "FeatureCollection",
            "features": [{
                "type": "Feature",
                "geometry": {
                    "type": "Point",
                    "coordinates": [102.0, 0.5]
                },
                "properties": {
                    "prop0": "value0"
                }
            }, {
                "type": "Feature",
                "geometry": {
                    "type": "LineString",
                    "coordinates": [
                        [102.0, 0.0],
                        [103.0, 1.0],
                        [104.0, 0.0],
                        [105.0, 1.0]
                    ]
                },
                "properties": {
                    "prop0": "value0",
                    "prop1": 0.0
                }
            }, {
                "type": "Feature",
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [
                        [
                            [100.0, 0.0],
                            [101.0, 0.0],
                            [101.0, 1.0],
                            [100.0, 1.0],
                            [100.0, 0.0]
                        ]
                    ]
                },
                "properties": {
                    "prop0": "value0",
                    "prop1": {
                        "this": "that"
                    }
                }
            }]
        }
        """.data(using: .utf8)!

        let geoJson = try JSONDecoder().decode(FeatureCollection.self, from: json)

        XCTAssertEqual(geoJson.features.count, 3)
        XCTAssertEqual(geoJson.features[0].geometry, .point(Point(longitude: 102.0, latitude: 0.5)))
        XCTAssertEqual(geoJson.features[0].properties?.prop0, "value0")

        guard case let .lineString(ls) = geoJson.features[1].geometry else { XCTFail(); return }
        XCTAssertEqual(ls.coordinates[0], Position(longitude: 102.0, latitude: 0.0))
        XCTAssertEqual(geoJson.features[1].properties?["prop1"], 0)

        guard case let .polygon(p) = geoJson.features[2].geometry else { XCTFail(); return }
        XCTAssertEqual(p.coordinates[0].coordinates.count, 5)
        XCTAssertEqual(geoJson.features[2].properties?.prop1, ["this": "that"])
    }
}
