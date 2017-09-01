import XCTest
@testable import rupert

class rupertTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(rupert().text, "Hello, World!")
    }


    static var allTests: [(String, (rupertTests) -> () -> Void)] = [
        ("testExample", testExample),
    ]
}
