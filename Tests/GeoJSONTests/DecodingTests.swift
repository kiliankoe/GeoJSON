import XCTest
import GeoJSON

final class DecodingTests: XCTestCase {
    func testDecodeBoundingBox() throws {
        let bbox4Json = "[-10.0, -10.0, 10.0, 10.0]".data(using: .utf8)!
        let bbox4 = try JSONDecoder().decode(BoundingBox.self, from: bbox4Json)
        XCTAssertEqual(bbox4.southWesterly.longitude, -10.0)
        XCTAssertEqual(bbox4.southWesterly.latitude, -10.0)
        XCTAssertEqual(bbox4.northEasterly.longitude, 10.0)
        XCTAssertEqual(bbox4.northEasterly.latitude, 10.0)

        let bbox6Json = "[100.0, 0.0, -100.0, 105.0, 1.0, 0.0]".data(using: .utf8)!
        let bbox6 = try JSONDecoder().decode(BoundingBox.self, from: bbox6Json)
        XCTAssertEqual(bbox6.southWesterly.longitude, 100.0)
        XCTAssertEqual(bbox6.southWesterly.latitude, 0.0)
        XCTAssertEqual(bbox6.southWesterly.altitude, -100.0)
        XCTAssertEqual(bbox6.northEasterly.longitude, 105.0)
        XCTAssertEqual(bbox6.northEasterly.latitude, 1.0)
        XCTAssertEqual(bbox6.northEasterly.altitude, 0.0)

        let illegalBbox = "[10.0, 10.0, 10.0]".data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(BoundingBox.self, from: illegalBbox))
    }

    func testDecodeHomepageExample() throws {
        let json = """
        {
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": [125.6, 10.1, 0, 0]
          },
          "properties": {
            "name": "Dinagat Islands"
          }
        }
        """.data(using: .utf8)!

        let feature = try JSONDecoder().decode(Feature.self, from: json)
        XCTAssertEqual(feature.geometry, .point(Point(longitude: 125.6, latitude: 10.1, altitude: 0.0)))
        XCTAssertEqual(feature.properties?["name"], "Dinagat Islands")
        XCTAssertEqual(feature.properties?.name, "Dinagat Islands")

        let document = try JSONDecoder().decode(GeoJSONDocument.self, from: json)
        guard case .feature(let docFeature) = document else {
            XCTFail()
            return
        }
        XCTAssertEqual(docFeature, feature)
    }

    func testDecodeFeatureWithId() throws {
        let featureWithIdJson = """
        {
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": [125.6, 10.1]
          },
          "properties": {
            "name": "Dinagat Islands"
          },
          "id": "DinagatIslands"
        }
        """.data(using: .utf8)!

        let featureWithId = try JSONDecoder().decode(Feature.self, from: featureWithIdJson)
        XCTAssertEqual(featureWithId.id, "DinagatIslands")

        let featureWithNumberIdJson = """
        {
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": [125.6, 10.1]
          },
          "properties": {
            "name": "Dinagat Islands"
          },
          "id": 100
        }
        """.data(using: .utf8)!

        let featureWithNumberId = try JSONDecoder().decode(Feature.self, from: featureWithNumberIdJson)
        XCTAssertEqual(featureWithNumberId.id, "100.0")
    }

    func testDecodeFeatureWithBoundingBox() throws {
        let json = """
        {
               "type": "Feature",
               "bbox": [-10.0, -10.0, 10.0, 10.0],
               "geometry": {
                   "type": "Polygon",
                   "coordinates": [
                       [
                           [-10.0, -10.0],
                           [10.0, -10.0],
                           [10.0, 10.0],
                           [-10.0, -10.0]
                       ]
                   ]
               }
           }
        """.data(using: .utf8)!

        let feature = try JSONDecoder().decode(Feature.self, from: json)
        XCTAssertNotNil(feature.boundingBox)
    }

    func testDecodeSpecExample1() throws {
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

        let document = try JSONDecoder().decode(GeoJSONDocument.self, from: json)
        guard case .featureCollection(let docFeatureCollection) = document else {
            XCTFail()
            return
        }
        // No need to validate the contents, which will likely fail due to dictionary ordering.
        XCTAssertEqual(docFeatureCollection.features.count, geoJson.features.count)
    }
}
