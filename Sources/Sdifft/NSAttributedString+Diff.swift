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

extension String {
    subscript(_ idx: Int) -> String {
        return String(self[index(startIndex, offsetBy: idx)])
    }
}

public struct DiffAttributes {
    public let insert, delete, same: [NSAttributedString.Key: Any]
    public init(
        insert: [NSAttributedString.Key: Any],
        delete: [NSAttributedString.Key: Any],
        same: [NSAttributedString.Key: Any]
    ) {
        self.insert = insert
        self.delete = delete
        self.same = same
    }
}

extension Array where Element == DiffScript {
    func reverseIndex<T>(source: [T], target: [T]) -> [DiffScript] {
        return map {
            switch $0 {
            case .delete(at: let idx):
                return DiffScript.delete(at: source.count - 1 - idx)
            case .insert(into: let idx):
                return DiffScript.insert(into: target.count - 1 - idx)
            case .same(at: let idx):
                return DiffScript.same(at: target.count - 1 - idx)
            }
        }
    }
}

extension NSAttributedString {
    private static func script<T: Equatable & Hashable>(withSource source: [T], target: [T]) -> [DiffScript] {
        // The results under normal conditions aren't humanable
        // because it's `Right-Left`
        // example:
        //      source: "hallo"
        //      target: "typo hello"
        //      result: "h{delete}type: he{insert}a{delete}llo{same}"
        //
        // If we reverse source and target, we will get the results that humanable
        // example:
        //      source: "hallo"
        //      target: "typo hello"
        //      result: "type: {insert}h{same}a{delete}e{insert}llo"
        return
            Diff(source: source.reversed(), target: target.reversed())
            .scripts
            .reverseIndex(source: source, target: target)
    }

    public convenience init(source: String, target: String, attributes: DiffAttributes) {
        let attributedString = NSMutableAttributedString()
        let scripts = NSAttributedString.script(withSource: .init(source), target: .init(target))

        scripts.forEach {
            switch $0 {
            case .insert(into: let idx):
                attributedString.append(NSAttributedString(string: target[idx], attributes: attributes.insert))
            case .delete(at: let idx):
                attributedString.append(NSAttributedString(string: source[idx], attributes: attributes.delete))
            case .same(at: let idx):
                attributedString.append(NSAttributedString(string: target[idx], attributes: attributes.same))
            }
        }

        self.init(attributedString: attributedString)
    }

    /// Difference between two lines
    ///
    /// - Parameters:
    ///   - source: source
    ///   - target: target
    ///   - attributes: attributes
    ///   - handler: handler of each script's attributedString
    ///
    ///   For example:
    ///     let attributedString =
    ///     NSAttributedString(source: source, target: target, attributes: attributes) { script, string in
    ///         let string = NSMutableAttributedString(attributedString: string)
    ///         string.append(NSAttributedString(string: "\n"))
    ///         return string
    ///     }
    public convenience init(
        source: [String], target: [String],
        attributes: DiffAttributes,
        handler: ((DiffScript, NSAttributedString) -> NSAttributedString)? = nil
    ) {
        let attributedString = NSMutableAttributedString()
        let scripts = NSAttributedString.script(withSource: source, target: target)
        scripts.forEach {
            var scriptAttributedString: NSAttributedString
            switch $0 {
            case .insert(into: let idx):
                scriptAttributedString = NSAttributedString(string: target[idx], attributes: attributes.insert)
            case .delete(at: let idx):
                scriptAttributedString = NSAttributedString(string: source[idx], attributes: attributes.delete)
            case .same(at: let idx):
                scriptAttributedString = NSAttributedString(string: target[idx], attributes: attributes.same)
            }
            if let handler = handler {
                scriptAttributedString = handler($0, scriptAttributedString)
            }
            attributedString.append(scriptAttributedString)
        }

        self.init(attributedString: attributedString)
    }
}
