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

/// LCS
///
/// - Parameters:
///   - from: string
///   - to: string that be compared
///   - position: current position
///   - matrix: matrix
///   - same: same character's indexes
/// - Returns: same character's indexes
func lcs(from: String, to: String, position: Position, matrix: Matrix, same: (from: [Int], to: [Int])) -> (from: [Int], to: [Int]) {
    if position.row == 0 || position.column == 0 {
        return same
    }
    if from[position.row - 1] == to[position.column - 1] {
        return lcs(from: from, to: to, position: (position.row - 1, position.column - 1), matrix: matrix, same: (same.from + [position.row - 1], same.to + [position.column - 1]))
    } else if matrix[position.row - 1][position.column] >= matrix[position.row][position.column - 1] {
        return lcs(from: from, to: to, position: (position.row - 1, position.column), matrix: matrix, same: same)
    } else {
        return lcs(from: from, to: to, position: (position.row, position.column - 1), matrix: matrix, same: same)
    }
}

extension Array where Element == Int {
    /// Get [Range<Int>] with [Int]
    /// - example: [0, 3, 4] -> [0...0, 3...4]
    func getSameRanges() -> [CountableClosedRange<Int>] {
        var ranges: [CountableClosedRange<Int>] = []
        var begin = first ?? 0
        enumerated().forEach { (idx, current) in
            guard count > idx + 1 else {
                ranges.append(begin...current)
                return
            }
            
            let next = self[idx + 1]
            if next - current != 1 {
                ranges.append(begin...current)
                begin = next
            }
        }
        return ranges
    }
    
    /// Get [Range<Int>] with [Int]
    /// - example: [0, 3, 4] -> [1...2]
    func getChangeRanges(max: Int) -> [CountableClosedRange<Int>] {
        if count == 0, max >= 0 {
            return [0...max]
        }
        var ranges: [CountableClosedRange<Int>] = []
        var begin = first ?? 0
        if begin != 0 {
            ranges.append(0...(begin - 1))
        }
        enumerated().forEach { (idx, current) in
            guard count > idx + 1 else {
                if current != max {
                    ranges.append((current + 1)...max)
                }
                return
            }

            let next = self[idx + 1]
            if next - current != 1 {
                ranges.append((current + 1)...(next - 1))
            }
            begin = next
        }
        return ranges
    }
}

public struct Modification {
    public enum Base {
        case from
        case to
    }
    
    public let add: [CountableClosedRange<Int>]
    public let delete: [CountableClosedRange<Int>]
    public let same: [CountableClosedRange<Int>]
    public let base: Base
    
    
    /// Return modification with strings
    ///
    /// - Parameters:
    ///   - from: string
    ///   - to: string that be compared
    ///   - matrix: matrix
    ///   - isReversed: from and to is reversed
    init(from: String, to: String, matrix: Matrix, isReversed: Bool) {
        var same =
            lcs(from: from, to: to, position: (from.count, to.count), matrix: matrix, same: ([], []))
        
        if isReversed {
            same = (
                same.from.map({ from.count - 1 - $0 }),
                same.to.map({ to.count - 1 - $0 })
            )
        }
        
        add = same.to.getChangeRanges(max: to.count - 1)
        delete = same.from.getChangeRanges(max: from.count - 1)
        if add.isEmpty {
            base = .from
            self.same = same.from.getSameRanges()
        } else {
            base = .to
            self.same = same.to.getSameRanges()
        }
    }
}

public struct Diff {
    public let modification: Modification
    let matrix: Matrix
    
    public init(from: String, to: String) {
        // because LCS is 'bottom-up'
        // so them need be reversed to get the normal sequence
        let reversedFrom = String(from.reversed())
        let reversedTo = String(to.reversed())
        matrix = drawMatrix(from: reversedFrom, to: reversedTo)
        modification = Modification(from: reversedFrom, to: reversedTo, matrix: matrix, isReversed: true)
    }
}
