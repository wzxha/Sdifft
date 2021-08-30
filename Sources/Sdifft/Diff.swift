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

// swiftlint:disable identifier_name
public enum DiffScript {
    case insert(into: Int)
    case delete(at: Int)
    case same(at: Int)
}

struct Vertice: Equatable {
    let x, y: Int
    static func == (lhs: Vertice, rhs: Vertice) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

struct Path {
    let from, to: Vertice
    let script: DiffScript
}

// swiftlint:disable identifier_name
public class Diff<T: Equatable & Hashable> {
    let scripts: [DiffScript]

    public init(source: [T], target: [T]) {
        if source.isEmpty, target.isEmpty {
            scripts = []
        } else if source.isEmpty, !target.isEmpty {
            // Under normal circumstances, scripts is a reversed (index) array
            // you need to reverse the array youself if need.
            scripts = (0..<target.count).reversed().compactMap { DiffScript.insert(into: $0) }
        } else if !source.isEmpty, target.isEmpty {
            scripts = (0..<source.count).reversed().compactMap { DiffScript.delete(at: $0) }
        } else {
            let paths = Diff.exploreEditGraph(source: source, target: target)
            scripts = Diff.reverseTree(paths: paths, sinkVertice: .init(x: target.count, y: source.count))
        }
    }

    static func exploreEditGraph(source: [T], target: [T]) -> [Path] {
        let max = source.count + target.count
        var furthest = Array(repeating: 0, count: 2 * max + 1)
        var paths: [Path] = []

        let snake: (Int, Int, Int) -> Int = { x, _, k in
            var _x = x
            var y: Int { return _x - k }
            while _x < target.count && y < source.count && source[y] == target[_x] {
                _x += 1
                paths.append(
                    Path(from: .init(x: _x - 1, y: y - 1), to: .init(x: _x, y: y), script: .same(at: _x - 1))
                )
            }
            return _x
        }

        for d in 0...max {
            for k in stride(from: -d, through: d, by: 2) {
                let index = k + max
                var x = 0
                var y: Int { return x - k }
                // swiftlint:disable statement_position
                if d == 0 { }
                else if k == -d || k != d && furthest[index - 1] < furthest[index + 1] {
                    // moving bottom
                    x = furthest[index + 1]
                    paths.append(
                        Path(
                            from: .init(x: x, y: y - 1), to: .init(x: x, y: y),
                            script: .delete(at: y - 1)
                        )
                    )
                } else {
                    // moving right
                    x = furthest[index - 1] + 1
                    paths.append(
                        Path(
                            from: .init(x: x - 1, y: y), to: .init(x: x, y: y),
                            script: .insert(into: x - 1)
                        )
                    )
                }
                x = snake(x, d, k)
                if x == target.count, y == source.count {
                    return paths
                }
                furthest[index] = x
            }
        }

        return []
    }

    // Search for the path from the back to the front
    static func reverseTree(paths: [Path], sinkVertice: Vertice) -> [DiffScript] {
        var scripts: [DiffScript] = []
        var next = sinkVertice
        paths.reversed().forEach {
            guard $0.to == next else { return }
            next = $0.from
            scripts.append($0.script)
        }
        return scripts
    }
}
