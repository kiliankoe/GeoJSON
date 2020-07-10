import XCTest
import GeoJSON

final class EncodingTests: XCTestCase {
    func testPointEncoding() throws {
        let p = Point(coordinates: Position(longitude: 1.0, latitude: 1.0))
        XCTAssertEqual(try jsonRepr(p, pretty: false), "[1,1]")
    }

    func testMultiPointEncoding() throws {
        let mp = MultiPoint(coordinates: [
            Position(longitude: 1.0, latitude: 1.0)
        ])
        XCTAssertEqual(try jsonRepr(mp, pretty: false), "[[1,1]]")
    }

    func testLineStringEncoding() throws {
        let ls = try LineString(coordinates: [
            Position(longitude: 1.0, latitude: 1.0),
            Position(longitude: 2.0, latitude: 2.0)
        ])
        XCTAssertEqual(try jsonRepr(ls, pretty: false), "[[1,1],[2,2]]")
    }

    func testMultiLineStringEncoding() throws {
        let mls = try MultiLineString(coordinates: [
            LineString(coordinates: [
                Position(longitude: 1.0, latitude: 1.0),
                Position(longitude: 2.0, latitude: 2.0)
            ])
        ])
        XCTAssertEqual(try jsonRepr(mls, pretty: false), "[[[1,1],[2,2]]]")
    }

    func testPolygonEncoding() throws {
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

    func testMultiPolygonEncoding() throws {
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

    func testEncodeFeature() throws {
        let featurePoint = Feature(
            geometry: .point(Point(coordinates: Position(longitude: 1.0, latitude: 1.0))),
            properties: ["SomeProperty": "SomeValue"]
        )
        XCTAssertEqual(try jsonRepr(featurePoint), """
        {
          "geometry" : {
            "coordinates" : [
              1,
              1
            ],
            "type" : "Point"
          },
          "properties" : {
            "SomeProperty" : "SomeValue"
          },
          "type" : "Feature"
        }
        """)
    }

    func testEncodeFeatureCollection() throws {
        let doc = FeatureCollection(features: [
            Feature(geometry: .point(Point(coordinates: Position(longitude: 1.0, latitude: 1.0)))),
            Feature(geometry: .multiPoint(MultiPoint(coordinates: [Position(longitude: 1.0, latitude: 1.0)])), properties: ["someProperty": 1])
        ])
        XCTAssertEqual(try jsonRepr(doc), """
        {
          "features" : [
            {
              "geometry" : {
                "coordinates" : [
                  1,
                  1
                ],
                "type" : "Point"
              },
              "properties" : null,
              "type" : "Feature"
            },
            {
              "geometry" : {
                "coordinates" : [
                  [
                    1,
                    1
                  ]
                ],
                "type" : "MultiPoint"
              },
              "properties" : {
                "someProperty" : 1
              },
              "type" : "Feature"
            }
          ],
          "type" : "FeatureCollection"
        }
        """)
    }

    func testEncodeReadmeExample() throws {
        let document = FeatureCollection(features: [
            Feature(
                geometry: .point(Point(longitude: 125.6, latitude: 10.1)),
                properties: [
                    "name": "Dinagat Island"
                ]
            )
        ])

        XCTAssertEqual(try jsonRepr(document), """
        {
          "features" : [
            {
              "geometry" : {
                "coordinates" : [
                  125.59999999999999,
                  10.1
                ],
                "type" : "Point"
              },
              "properties" : {
                "name" : "Dinagat Island"
              },
              "type" : "Feature"
            }
          ],
          "type" : "FeatureCollection"
        }
        """)
    }
}

extension EncodingTests {
    func jsonRepr<T: Encodable>(_ json: T, pretty: Bool = true) throws -> String {
        let encoder = JSONEncoder()
        if pretty {
            encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        } else {
            encoder.outputFormatting = [.sortedKeys]
        }
        let data = try encoder.encode(json)
        return String(data: data, encoding: .utf8)!
    }
}
