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

extension String {
    /// Return character in string
    ///
    /// - Parameter idx: index
    subscript (idx: Int) -> Character {
        return self[index(startIndex, offsetBy: idx)]
    }
}

typealias Matrix = [[Int]]

/// Draw LCS matrix with two strings
///
/// - Parameters:
///   - from: string
///   - to: string that be compared
/// - Returns: matrix
func drawMatrix(from: String, to: String) -> Matrix {
    let row = from.count + 1
    let column = to.count + 1
    var result: [[Int]] = Array(repeating: Array(repeating: 0, count: column), count: row)
    for i in 1..<row {
        for j in 1..<column {
            if from[i - 1] == to[j - 1] {
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

/// LCS
///
/// - Parameters:
///   - from: string
///   - to: string that be compared
///   - position: current position
///   - matrix: matrix
///   - same: same character's indexes
/// - Returns: same character's indexes
func lcs(from: String, to: String, position: Position, matrix: Matrix, same: [DiffIndex]) -> [DiffIndex] {
    if position.row == 0 || position.column == 0 {
        return same
    }
    if from[position.row - 1] == to[position.column - 1] {
        return lcs(from: from, to: to, position: (position.row - 1, position.column - 1), matrix: matrix, same: same + [(position.row - 1, position.column - 1)])
    } else if matrix[position.row - 1][position.column] >= matrix[position.row][position.column - 1] {
        return lcs(from: from, to: to, position: (position.row - 1, position.column), matrix: matrix, same: same)
    } else {
        return lcs(from: from, to: to, position: (position.row, position.column - 1), matrix: matrix, same: same)
    }
}

public struct Modification {
    public let add: String?
    public let delete: String?
    public let same: String?
}

extension String {
    /// Return string with range
    ///
    /// - Parameter range: range
    subscript(_ range: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start...end])
    }
}

extension Array where Element == DiffIndex {
    func modifications(from: String, to: String) -> [Modification] {
        var modifications: [Modification] = []
        var lastFrom = 0
        var lastTo = 0
        modifications += map {
            let modification =
                Modification(
                    add: lastTo <= $0.to - 1 ? to[lastTo...$0.to - 1] : nil,
                    delete: lastFrom <= $0.from - 1 ? from[lastFrom...$0.from - 1] : nil,
                    same: to[$0.to...$0.to]
            )
            lastFrom = $0.from + 1
            lastTo = $0.to + 1
            return modification
        }
        if lastFrom <= from.count - 1 || lastTo <= to.count - 1 {
            modifications.append(
                Modification(
                    add: lastTo <= to.count - 1 ? to[lastTo...to.count - 1] : nil,
                    delete: lastFrom <= from.count - 1 ? from[lastFrom...from.count - 1] : nil,
                    same: nil
                )
            )
        }
        return modifications
    }
}

public struct Diff {
    public let modifications: [Modification]
    let matrix: Matrix
    let from: String
    let to: String
    public init(from: String, to: String) {
        // because LCS is 'bottom-up'
        // so them need be reversed to get the normal sequence
        self.from = from
        self.to = to
        let reversedFrom = String(from.reversed())
        let reversedTo = String(to.reversed())
        matrix = drawMatrix(from: reversedFrom, to: reversedTo)
        var same = lcs(from: reversedFrom, to: reversedTo, position: (from.count, to.count), matrix: matrix, same: [])
        same = same.map({ (from.count - 1 - $0, to.count - 1 - $1) })
        modifications = same.modifications(from: from, to: to)
    }
}
