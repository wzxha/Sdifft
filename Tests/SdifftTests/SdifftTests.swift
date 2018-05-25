import XCTest
@testable import Sdifft

extension String {
    subscript(_ range: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start...end])
    }
}

class DiffTests: XCTestCase {
    func testMatrix() {
        assert(
            drawMatrix(from: "abcd", to: "acd") == [
                [0, 0, 0, 0],
                [0, 1, 1, 1],
                [0, 1, 1, 1],
                [0, 1, 2, 2],
                [0, 1, 2, 3]
            ]
        )
        
        assert(
            drawMatrix(from: "abcdegh", to: "ae") == [
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
            drawMatrix(from: "adf", to: "d") == [
                [0, 0],
                [0, 0],
                [0, 1],
                [0, 1],
            ]
        )
        
        assert(
            drawMatrix(from: "d", to: "adf") == [
                [0, 0, 0, 0],
                [0, 0, 1, 1]
            ]
        )
        
        assert(
             drawMatrix(from: "", to: "") == [
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
        
        let to1 = "abcd"
        let from1 = "b"
        let diff1 = Diff(from: from1, to: to1)
        assert(diff1.modification.add == [0...0, 2...3])
        assert(diff1.modification.delete == [])
        assert(diff1.modification.same == [1...1])
        
        let to2 = "abcd"
        let from2 = "bx"
        let diff2 = Diff(from: from2, to: to2)
        assert(diff2.modification.add == [0...0, 2...3])
        assert(diff2.modification.delete == [1...1])
        assert(diff2.modification.same == [1...1])
        
        let to3 = "A\r\nB\r\nC"
        let from3 = "A\r\n\r\nB\r\n\r\nC"
        let diff3 = Diff(from: from3, to: to3)
        assert(diff3.modification.add == [])
        assert(diff3.modification.delete == [2...2, 5...5])
        assert(diff3.modification.same == [0...1, 3...4, 6...6])
    }
    
    func testString1() {
        let to = "abcdhijk"
        let from = "bj"
        let diff = Diff(from: from, to: to)
        assert(
            to[diff.modification.add[0]] == "a" &&
            to[diff.modification.add[1]] == "cdhi" &&
            to[diff.modification.add[2]] == "k" &&
            diff.modification.delete.count == 0 &&
            to[diff.modification.same[0]] == "b" &&
            to[diff.modification.same[1]] == "j")
    }
    
    func testString2() {
        let to = "abcdhijk"
        let from = "bexj"
        let diff = Diff(from: from, to: to)
        assert(
            to[diff.modification.add[0]] == "a" &&
            to[diff.modification.add[1]] == "cdhi" &&
            to[diff.modification.add[2]] == "k" &&
            from[diff.modification.delete[0]] == "ex" &&
            to[diff.modification.same[0]] == "b" &&
            to[diff.modification.same[1]] == "j"
        )
    }
    
    func testString3() {
        let to = "A\r\nB\r\nC"
        let from = "A\r\n\r\nB\r\n\r\nC"
        let diff = Diff(from: from, to: to)
        assert(
            diff.modification.add.count == 0 &&
            from[diff.modification.delete[0]] == "\r\n" &&
            (diff.modification.base == .to ? to[diff.modification.same[0]]: from[diff.modification.same[0]]) == "A\r\n" &&
            (diff.modification.base == .to ? to[diff.modification.same[1]]: from[diff.modification.same[1]]) == "B\r\n" &&
            (diff.modification.base == .to ? to[diff.modification.same[2]]: from[diff.modification.same[2]]) == "C"
        )
    }

    func testTime() {
        // 1000 character * 1000 character: 3.681s
        measure {
            let _ =
            Diff(
                from: "abcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkbexjabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijk123abcdhijkabcdhijkabcdhijkabcdhijk12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123",
                to: "abcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijk"
            )
        }
    }
    
    static var allTests = [
        ("testMatrix", testMatrix),
        ("testRange", testRange),
        ("testString1", testString1),
        ("testString2", testString2),
        ("testString3", testString3),
        ("testTime", testTime)
    ]
}
