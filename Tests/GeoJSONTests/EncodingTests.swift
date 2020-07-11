import XCTest
import GeoJSON

final class EncodingTests: XCTestCase {
    func testEncodeBoundingBox() throws {
        let bbox4 = BoundingBox(southWesterly: Position(longitude: 10.0, latitude: 10.0),
                                northEasterly: Position(longitude: -10.0, latitude: -10.0))
        XCTAssertEqual(try jsonRepr(bbox4, pretty: false), "[10,10,-10,-10]")

        let bbox4Alt = BoundingBox(southWesterly: Position(longitude: 10.0, latitude: 10.0, altitude: 2.0),
                                   northEasterly: Position(longitude: -10.0, latitude: -10.0))
        XCTAssertEqual(try jsonRepr(bbox4Alt, pretty: false), "[10,10,-10,-10]")

        let bbox6 = BoundingBox(southWesterly: Position(longitude: 10.0, latitude: 10.0, altitude: -2.0),
                                northEasterly: Position(longitude: -10.0, latitude: -10.0, altitude: 2.0))
        XCTAssertEqual(try jsonRepr(bbox6, pretty: false), "[10,10,-2,-10,-10,2]")
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

    func testEncodeEmptyFeature() throws {
        let feature = Feature(geometry: nil)
        XCTAssertEqual(try jsonRepr(feature, pretty: true), """
        {
          "geometry" : null,
          "properties" : null,
          "type" : "Feature"
        }
        """)
    }

    func testEncodeFeatureCollection() throws {
        let featureCollection = FeatureCollection(features: [
            Feature(geometry: .point(Point(coordinates: Position(longitude: 1.0, latitude: 1.0)))),
            Feature(geometry: .multiPoint(MultiPoint(coordinates: [Position(longitude: 1.0, latitude: 1.0)])), properties: ["someProperty": 1])
        ])
        XCTAssertEqual(try jsonRepr(featureCollection), """
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

        let featureCollectionWithBoundingBox = FeatureCollection(
            features: [],
            boundingBox: BoundingBox(southWesterly: Position(longitude: 10.0, latitude: 10.0),
                                     northEasterly: Position(longitude: -10.0, latitude: -10.0))
        )
        XCTAssertEqual(try jsonRepr(featureCollectionWithBoundingBox), """
        {
          "bbox" : [
            10,
            10,
            -10,
            -10
          ],
          "features" : [

          ],
          "type" : "FeatureCollection"
        }
        """)
    }

    func testEncodeHomepageExample() throws {
        let feature = Feature(
            geometry: .point(Point(longitude: 125.6, latitude: 10.1)),
            properties: [
                "name": "Dinagat Islands"
            ]
        )

        XCTAssertEqual(try jsonRepr(feature), """
        {
          "geometry" : {
            "coordinates" : [
              125.59999999999999,
              10.1
            ],
            "type" : "Point"
          },
          "properties" : {
            "name" : "Dinagat Islands"
          },
          "type" : "Feature"
        }
        """)
    }
}
