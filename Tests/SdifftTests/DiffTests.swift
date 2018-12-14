import XCTest
@testable import Sdifft

extension Array where Element == DiffScript {
    var description: String {
        var description = ""
        forEach {
            switch $0 {
            case .delete(at: let idx):
                description += "D{\(idx)}"
            case .insert(into: let idx):
                description += "I{\(idx)}"
            case .same(at: let idx):
                description += "U{\(idx)}"
            }
        }
        return description
    }
}

class DiffTests: XCTestCase {
    func testDiff() {
        let scripts = Diff(source: .init("b"), target: .init("abcd")).scripts

        
        let expectations = [
            ("abc", "abc", "U{2}U{1}U{0}"),
            ("abc", "ab", "D{2}U{1}U{0}"),
            ("ab", "abc", "I{2}U{1}U{0}"),
            ("", "abc", "I{2}I{1}I{0}"),
            ("abc", "", "D{2}D{1}D{0}"),
            ("b", "ac", "D{0}I{1}I{0}"),
            ("", "", "")
        ]
        expectations.forEach {
            let scripts = Diff(source: .init($0.0), target: .init($0.1)).scripts
            XCTAssertTrue(
                scripts.description == $0.2,
                "\(scripts.description) is no equal to \($0.2)"
            )
        }
    }

    // swiftlint:disable line_length
    func testTime() {
        // 1000 character * 1000 character: 0.8s
        measure {
            _ =
            Diff(
                source: .init("abcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkbexjabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijk123abcdhijkabcdhijkabcdhijkabcdhijk12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123k12213123"),
                target: .init("abcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijkabcdhijk")
            )
        }
    }

    static var allTests = [
        ("testDiff", testDiff),
        ("testTime", testTime)
    ]
}
