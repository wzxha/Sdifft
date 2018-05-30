import XCTest
@testable import Sdifft

extension Array where Element == Modification {
    var sames: [String] {
        return compactMap { $0.same }
    }
    var adds: [String] {
        return compactMap { $0.add }
    }
    var deletes: [String] {
        return compactMap { $0.delete }
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
                [0, 1]
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
                [0]
            ]
        )
    }

    func testStringRange() {
        assert(
            "abc"[0] == "a"
        )
        assert(
            "abc"[1] == "b"
        )
        assert(
            "abc"[2] == "c"
        )
    }

    func testModification() {
        let to1 = "abcd"
        let from1 = "b"
        let diff1 = Diff(from: from1, to: to1)
        assert(
            diff1.modifications.sames == ["b"] &&
            diff1.modifications.adds == ["a", "cd"] &&
            diff1.modifications.deletes == []
        )
        let to2 = "abcd"
        let from2 = "bx"
        let diff2 = Diff(from: from2, to: to2)
        assert(
            diff2.modifications.sames == ["b"] &&
            diff2.modifications.adds == ["a", "cd"] &&
            diff2.modifications.deletes == ["x"]
        )
        let to3 = "A\r\nB\r\nC"
        let from3 = "A\r\n\r\nB\r\n\r\nC"
        let diff3 = Diff(from: from3, to: to3)
        assert(
            diff3.modifications.sames == ["A", "\r\n", "B", "\r\n", "C"] &&
            diff3.modifications.adds == [] &&
            diff3.modifications.deletes == ["\r\n", "\r\n"]
        )
    }

    // swiftlint:disable line_length
    func testTime() {
        // 1000 character * 1000 character: 3.540s
        measure {
            _ =
            Diff(
                from: "abcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkbexjabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijk123abcdhijkabcdhijkabcdhijkabcdhijk12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123",
                to: "abcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijk"
            )
        }
    }

    static var allTests = [
        ("testMatrix", testMatrix),
        ("testStringRange", testStringRange),
        ("testModification", testModification),
        ("testTime", testTime)
    ]
}
