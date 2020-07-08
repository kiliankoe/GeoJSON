import XCTest
import GeoJSON

final class DecodingTests: XCTestCase {
    func testDecodeExample() throws {
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
    }
}
