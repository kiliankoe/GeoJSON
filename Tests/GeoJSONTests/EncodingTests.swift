import XCTest
@testable import GeoJSON

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
