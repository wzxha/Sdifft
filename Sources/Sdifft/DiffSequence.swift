//
//  DiffSequence.swift
//  Sdifft
//
//  Created by WzxJiang on 18/5/23.
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

public protocol DiffSequence: Equatable {
    func index(of idx: Int) -> Self
    func element(withRange range: CountableClosedRange<Int>) -> Self
    func reversedElement() -> Self
    var count: Int { get }
}

extension String: DiffSequence {
    public func index(of idx: Int) -> String {
        return String(self[index(startIndex, offsetBy: idx)])
    }
    public func element(withRange range: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start...end])
    }
    public func reversedElement() -> String {
        return String(reversed())
    }
}

extension Array: DiffSequence where Element == String {
    public func index(of idx: Int) -> [Element] {
        return [self[idx]]
    }
    public func element(withRange range: CountableClosedRange<Int>) -> [Element] {
        return Array(self[range])
    }
    public func reversedElement() -> [Element] {
        return reversed()
    }
}
