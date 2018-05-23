import XCTest
@testable import Diff

class DiffTests: XCTestCase {
    func testMatrix() {
        assert(
            Diff(from: "abcd", to: "acd").matrix == [
                [0, 0, 0, 0],
                [0, 1, 1, 1],
                [0, 1, 1, 1],
                [0, 1, 2, 2],
                [0, 1, 2, 3]
            ]
        )
        
        assert(
            Diff(from: "abcdegh", to: "ae").matrix == [
                [0, 0, 0],
                [0, 1, 1],
                [0, 1, 1],
                [0, 1, 1],
                [0, 1, 1],
                [0, 1, 2],
                [0, 1, 2],
                [0, 1, 2]
            ]
        )
        
        assert(
            Diff(from: "adf", to: "d").matrix == [
                [0, 0],
                [0, 0],
                [0, 1],
                [0, 1],
            ]
        )
        
        assert(
            Diff(from: "d", to: "adf").matrix == [
                [0, 0, 0, 0],
                [0, 0, 1, 1]
            ]
        )
        
        assert(
            Diff(from: "", to: "").matrix == [
                [0],
            ]
        )
    }

    func testRange() {
        assert(
            [0, 1, 3].getSameRanges() == [
                0...1,
                3...3
            ]
        )
        
        assert(
            [0, 1, 2, 3].getSameRanges() == [
                0...3
            ]
        )
        
        assert(
            [3, 5].getSameRanges() == [
                3...3,
                5...5
            ]
        )
        
        assert(
            [5, 6, 7].getSameRanges() == [
                5...7
            ]
        )
        
        assert(
            [].getSameRanges() == []
        )
        
        assert(
            [0, 1, 3].getChangeRanges(max: 10) == [
                2...2,
                4...10
            ]
        )
        
        assert(
            [0, 1, 2, 3].getChangeRanges(max: 10) == [
                4...10
            ]
        )
        
        assert(
            [3, 5].getChangeRanges(max: 10) == [
                0...2,
                4...4,
                6...10
            ]
        )
        
        assert(
            [5, 6, 7].getChangeRanges(max: 10) == [
                0...4,
                8...10,
            ]
        )
        
        assert(
            [].getChangeRanges(max: 10) == [
                0...10
            ]
        )
    }
    
    func testString1() {
        let from = "abcdhijk"
        let to = "bj"
        let diff = Diff(from: from, to: to)
        assert(
            (from as NSString).substring(with: NSRange(diff.modification.add[0])) == "a" &&
            (from as NSString).substring(with: NSRange(diff.modification.add[1])) == "cdhi" &&
            (from as NSString).substring(with: NSRange(diff.modification.add[2])) == "k" &&
            diff.modification.delete.count == 0 &&
            (from as NSString).substring(with: NSRange(diff.modification.same[0])) == "b" &&
            (from as NSString).substring(with: NSRange(diff.modification.same[1])) == "j")
    }
    
    func testString2() {
        let from = "abcdhijk"
        let to = "bexj"
        let diff = Diff(from: from, to: to)
        assert(
            (from as NSString).substring(with: NSRange(diff.modification.add[0])) == "a" &&
            (from as NSString).substring(with: NSRange(diff.modification.add[1])) == "cdhi" &&
            (from as NSString).substring(with: NSRange(diff.modification.add[2])) == "k" &&
            (to as NSString).substring(with: NSRange(diff.modification.delete[0])) == "ex" &&
            (from as NSString).substring(with: NSRange(diff.modification.same[0])) == "b" &&
            (from as NSString).substring(with: NSRange(diff.modification.same[1])) == "j"
        )
    }

    static var allTests = [
        ("testMatrix", testMatrix),
        ("testRange", testRange),
        ("testString1", testString1),
        ("testString2", testString2)
    ]
}
