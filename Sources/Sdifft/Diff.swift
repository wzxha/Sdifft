//
//  Diff.swift
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

typealias Matrix = [[Int]]

// swiftlint:disable identifier_name
/// Draw LCS matrix with two `DiffSequence`
///
/// - Parameters:
///   - from: DiffSequence
///   - to: DiffSequence that be compared
/// - Returns: matrix
func drawMatrix<T: DiffSequence>(from: T, to: T) -> Matrix {
    let row = from.count + 1
    let column = to.count + 1
    var result: [[Int]] = Array(repeating: Array(repeating: 0, count: column), count: row)
    for i in 1..<row {
        for j in 1..<column {
            if from.index(of: i - 1) == to.index(of: j - 1) {
                result[i][j] = result[i - 1][j - 1] + 1
            } else {
                result[i][j] = max(result[i][j - 1], result[i - 1][j])
            }
        }
    }
    return result
}

typealias Position = (row: Int, column: Int)
typealias DiffIndex = (from: Int, to: Int)

// swiftlint:disable line_length
/// LCS
///
/// - Parameters:
///   - from: DiffSequence
///   - to: DiffSequence that be compared
///   - position: current position
///   - matrix: matrix
///   - same: same element's indexes
/// - Returns: same element's indexes
func lcs<T: DiffSequence>(from: T, to: T, position: Position, matrix: Matrix, same: [DiffIndex]) -> [DiffIndex] {
    if position.row == 0 || position.column == 0 {
        return same
    }
    if from.index(of: position.row - 1) == to.index(of: position.column - 1) {
        return lcs(from: from, to: to, position: (position.row - 1, position.column - 1), matrix: matrix, same: same + [(position.row - 1, position.column - 1)])
    } else if matrix[position.row - 1][position.column] >= matrix[position.row][position.column - 1] {
        return lcs(from: from, to: to, position: (position.row - 1, position.column), matrix: matrix, same: same)
    } else {
        return lcs(from: from, to: to, position: (position.row, position.column - 1), matrix: matrix, same: same)
    }
}

public struct Modification<Element: DiffSequence> {
    public let add, delete, same: Element?
}

extension Array where Element == DiffIndex {
    func modifications<T: DiffSequence>(from: T, to: T) -> [Modification<T>] {
        var modifications: [Modification<T>] = []
        var lastFrom = 0
        var lastTo = 0
        modifications += map {
            let modification =
                Modification<T>(
                    add: lastTo <= $0.to - 1 ? to.element(withRange: lastTo...$0.to - 1) : nil,
                    delete: lastFrom <= $0.from - 1 ? from.element(withRange: lastFrom...$0.from - 1) : nil,
                    same: to.element(withRange: $0.to...$0.to)
                )
            lastFrom = $0.from + 1
            lastTo = $0.to + 1
            return modification
        }
        if lastFrom <= from.count - 1 || lastTo <= to.count - 1 {
            modifications.append(
                Modification<T>(
                    add: lastTo <= to.count - 1 ? to.element(withRange: lastTo...to.count - 1) : nil,
                    delete: lastFrom <= from.count - 1 ? from.element(withRange: lastFrom...from.count - 1) : nil,
                    same: nil
                )
            )
        }
        return modifications
    }
}

public struct Diff<T: DiffSequence> {
    public let modifications: [Modification<T>]
    let matrix: Matrix
    let from, to: T
    public init(from: T, to: T) {
        self.from = from
        self.to = to
        // because LCS is 'bottom-up'
        // so them need be reversed to get the normal sequence
        let reversedFrom = from.reversedElement()
        let reversedTo = to.reversedElement()
        matrix = drawMatrix(from: reversedFrom, to: reversedTo)
        var same = lcs(from: reversedFrom, to: reversedTo, position: (from.count, to.count), matrix: matrix, same: [])
        same = same.map { (from.count - 1 - $0, to.count - 1 - $1) }
        modifications = same.modifications(from: from, to: to)
    }
}
