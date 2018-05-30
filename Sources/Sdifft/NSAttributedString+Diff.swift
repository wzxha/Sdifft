//
//  NSAttributedString+Diff.swift
//  Sdifft
//
//  Created by WzxJiang on 18/5/29.
//  Copyright © 2018年 WzxJiang. All rights reserved.
//
//  https://github.com/Wzxhaha/Sdifft
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

public struct DiffAttributes {
    public let add: [NSAttributedStringKey: Any]
    public let delete: [NSAttributedStringKey: Any]
    public let same: [NSAttributedStringKey: Any]
    // swiftlint:disable line_length
    public init(add: [NSAttributedStringKey: Any], delete: [NSAttributedStringKey: Any], same: [NSAttributedStringKey: Any]) {
        self.add = add
        self.delete = delete
        self.same = same
    }
}

extension NSAttributedString {
    /// Get attributedString with `Diff` and attributes
    ///
    /// - Parameters:
    ///   - diff: Diff
    ///   - attributes: DiffAttributes
    /// - Returns: NSAttributedString
    public static func attributedString(with diff: Diff, attributes: DiffAttributes) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        diff.modifications.forEach {
            if let add = $0.add {
                attributedString.append(NSAttributedString(string: add, attributes: attributes.add))
            }
            if let delete = $0.delete {
                attributedString.append(NSAttributedString(string: delete, attributes: attributes.delete))
            }
            if let same = $0.same {
                attributedString.append(NSAttributedString(string: same, attributes: attributes.same))
            }
        }
        return attributedString
    }
}
