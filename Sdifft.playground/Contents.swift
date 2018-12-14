import UIKit
import Sdifft

// Difference between two strings
let source = "Hallo world"
let target = "typo: Hello World!"

let font = UIFont.systemFont(ofSize: 20)
let insertAttributes: [NSAttributedString.Key: Any] = [
    .backgroundColor: UIColor.green,
    .font: font
]
let deleteAttributes: [NSAttributedString.Key: Any] = [
    .backgroundColor: UIColor.red,
    .font: font,
    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
    .strikethroughColor: UIColor.red,
    .baselineOffset: 0
]

let sameAttributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.black,
    .font: font
]

let attributedString1 =
    NSAttributedString(
        source: source, target: target,
        attributes: DiffAttributes(insert: insertAttributes, delete: deleteAttributes, same: sameAttributes)
    )

// Difference between two lines
let sourceLines = ["I'm coding with Swift"]
let targetLines = ["Today", "I'm coding with Swift", "lol"]

let attributedString2 =
    NSAttributedString(
        source: sourceLines, target: targetLines,
        attributes: DiffAttributes(insert: insertAttributes, delete: deleteAttributes, same: sameAttributes)
    )
