import XCTest
@testable import Sdifft
#if os(OSX)
import AppKit
typealias Color = NSColor
#elseif os(iOS)
import UIKit
typealias Color = UIColor
#endif

extension String {
    subscript(range: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start...end])
    }
}

extension CGColor: CustomStringConvertible {
    public var description: String {
        let comps: [CGFloat] = components ?? [0, 0, 0, 0]
        if comps == [1, 0, 0, 1] {
            return "{D}"
        } else if comps == [0, 1, 0, 1] {
            return "{I}"
        } else {
            return "{U}"
        }
    }
}

extension NSAttributedString {
    open override var description: String {
        var description = ""
        enumerateAttributes(
            in: NSRange(location: 0, length: string.count),
            options: .longestEffectiveRangeNotRequired) { (attributes, range, _) in
            let color = attributes[NSAttributedString.Key.backgroundColor] as? Color ?? Color.black
            description += string[range.location...range.location + range.length - 1] + color.cgColor.description
        }
        return description
    }
}

class NSAttributedStringDiffTests: XCTestCase {
    let insertAttributes: [NSAttributedString.Key: Any] = [
        .backgroundColor: Color.green
    ]

    let deleteAttributes: [NSAttributedString.Key: Any] = [
        .backgroundColor: Color.red,
        .strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue,
        .strikethroughColor: Color.red,
        .baselineOffset: 0
    ]

    let sameAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: Color.black
    ]

    func testAttributedString() {
        let expectations = [
            ("abc", "abc", "abc{U}"),
            ("abc", "ab", "ab{U}c{D}"),
            ("ab", "abc", "ab{U}c{I}"),
            ("", "abc", "abc{I}"),
            ("abc", "", "abc{D}"),
            ("b", "ac", "b{D}ac{I}"),
            ("abc", "ac", "a{U}b{D}c{U}"),
            ("", "", "")
        ]
        expectations.forEach {
            let string =
                NSAttributedString(
                    source: $0.0, target: $0.1,
                    attributes: DiffAttributes(insert: insertAttributes, delete: deleteAttributes, same: sameAttributes)
                )
            XCTAssertTrue(
                string.description == $0.2,
                "\(string.description) is no equal to \($0.2)"
            )
        }
    }

    func testLines() {
        let expectations: [([String], [String], [String])] = [
            (["a", "b", "c"], ["a", "b", "c"], ["a", "b", "c"]),
            (["a", "b", "c"], ["a", "b"], ["a", "b", "-c"]),
            (["a", "b"], ["a", "b", "c"], ["a", "b", "+c"]),
            ([], ["a", "b", "c"], ["+a", "+b", "+c"]),
            (["a", "b", "c"], [], ["-a", "-b", "-c"]),
            (["b"], ["a", "c"], ["-b", "+a", "+c"]),
            (["a", "b", "c"], ["a", "c"], ["a", "-b", "c"]),
            ([], [], [])
        ]
        expectations.forEach {
            let string =
                NSAttributedString(
                    source: $0.0, target: $0.1,
                    attributes: DiffAttributes(
                        insert: insertAttributes,
                        delete: deleteAttributes,
                        same: sameAttributes)
                    ) { script, string in
                        let string = NSMutableAttributedString(attributedString: string)
                        string.append(NSAttributedString(string: "\n"))
                        switch script {
                        case .delete:
                            string.insert(NSAttributedString(string: "-"), at: 0)
                        case .insert:
                            string.insert(NSAttributedString(string: "+"), at: 0)
                        case .same:
                            break
                        }
                        return string
                    }
            let result = string.string.split(separator: "\n").map { String($0) }
            XCTAssertTrue(
                result == $0.2,
                "\(result) is no equal to \($0.2)"
            )
        }
    }

    static var allTests = [
        ("testAttributedString", testAttributedString),
        ("testLines", testLines)
    ]
}
