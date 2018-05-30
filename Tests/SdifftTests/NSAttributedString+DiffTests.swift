import XCTest
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
    open override var description: String {
        var description = ""
        enumerateAttributes(in: NSRange(location: 0, length: string.count), options: .longestEffectiveRangeNotRequired) { (attributes, range, stop) in
            let color = attributes[NSAttributedStringKey.backgroundColor] as? NSColor ?? NSColor.black
            description += string[range.location...range.location + range.length - 1] + color.cgColor.description
        }
        return description
    }
}

class NSAttributedString_DiffTests: XCTestCase {
    func testAttributedString() {
        let diffAttributes = DiffAttributes(add: [NSAttributedStringKey.backgroundColor: NSColor.green], delete: [NSAttributedStringKey.backgroundColor: NSColor.red], same: [NSAttributedStringKey.backgroundColor: NSColor.black])
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
        
//        let to3 = "A\r\nB\r\nC"
//        let from3 = "A\r\n\r\nB\r\n\r\nC"
//        let diff3 = Diff(from: from3, to: to3)
//        let attributedString3 = NSAttributedString.attributedString(with: diff3, attributes: diffAttributes)
//        assert(
//            attributedString3.debugDescription == "A\r\n{black}\r\n{red}B\r\n{black}\r\n{red}C{black}"
//        )
    }
    
    static var allTests = [
        ("testAttributedString", testAttributedString)
    ]
}
