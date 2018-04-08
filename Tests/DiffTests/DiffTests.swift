import XCTest
@testable import Diff

class DiffTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let x = "abcd"
        let y = "acd"
        let diff = Diff(from: x, to: y)
        diff.matrix.forEach {
            print($0)
        }
        
        
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
