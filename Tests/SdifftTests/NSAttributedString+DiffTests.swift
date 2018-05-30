import XCTest
import Foundation
@testable import Sdifft

extension CGColor: CustomStringConvertible {
    public var description: String {
        let comps: [CGFloat] = components ?? [0, 0, 0, 0]
        if comps == [1, 0, 0, 1] {
            return "{red}"
        } else if comps == [0, 1, 0, 1] {
            return "{green}"
        } else {
            return "{black}"
        }
    }
}

extension NSAttributedString {
    // swiftlint:disable line_length
    open override var description: String {
        var description = ""
        enumerateAttributes(in: NSRange(location: 0, length: string.count), options: .longestEffectiveRangeNotRequired) { (attributes, range, _) in
            let color = attributes[NSAttributedStringKey.backgroundColor] as? NSColor ?? NSColor.black
            description += string[range.location...range.location + range.length - 1] + color.cgColor.description
        }
        return description
    }
}

class NSAttributedStringDiffTests: XCTestCase {
    // swiftlint:disable line_length
    func testAttributedString() {
        let diffAttributes = DiffAttributes(add: [.backgroundColor: NSColor.green], delete: [.backgroundColor: NSColor.red], same: [.backgroundColor: NSColor.black])
        let to1 = "abcdhijk"
        let from1 = "bexj"
        let diff1 = Diff(from: from1, to: to1)
        let attributedString1 = NSAttributedString.attributedString(with: diff1, attributes: diffAttributes)
        assert(
            attributedString1.debugDescription == "a{green}b{black}cdhi{green}ex{red}j{black}k{green}"
        )
        let to2 = "bexj"
        let from2 = "abcdhijk"
        let diff2 = Diff(from: from2, to: to2)
        let attributedString2 = NSAttributedString.attributedString(with: diff2, attributes: diffAttributes)
        assert(
            attributedString2.debugDescription == "a{red}b{black}ex{green}cdhi{red}j{black}k{red}"
        )
    }

    static var allTests = [
        ("testAttributedString", testAttributedString)
    ]
}
