import XCTest
@testable import GeoJSON

final class GeoJSONTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(GeoJSON().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
