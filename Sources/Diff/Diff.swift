extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

typealias Matrix = [[Int]]

func draw(from: String, to: String) -> [[Int]] {
    let l = from.utf8.count + 1
    let m = to.utf8.count + 1
    var result: [[Int]] = Array(repeating: Array(repeating: 0, count: m), count: l)
    for i in 1..<l {
        for j in 1..<m {
            if from[i-1] == to[j-1] {
                result[i][j] = result[i-1][j-1] + 1
            } else {
                result[i][j] = max(result[i][j-1], result[i-1][j])
            }
        }
    }
    return result
}

func lcs(from: String, to: String, i: Int, j: Int, matrix: Matrix, change: (from: [Int], to: [Int])) -> (from: [Int], to: [Int]) {
    if i == 0 || j == 0 {
        return change
    }
    if from[i-1] == to[j-1] {
        return lcs(from: from, to: to, i: i - 1, j: j - 1, matrix: matrix, change: (change.from + [i-1], change.to + [j-1]))
    } else if matrix[i-1][j] >= matrix[i][j-1] {
        return lcs(from: from, to: to, i: i - 1, j: j, matrix: matrix, change: change)
    } else {
        return lcs(from: from, to: to, i: i, j: j - 1, matrix: matrix, change: change)
    }
}

public struct Diff {
    public let from: String
    public let to: String
    public let change: Change
    let matrix: Matrix
    
    public init(from: String, to: String) {
        self.from = from
        self.to = to
        self.matrix = draw(from: from, to: to)
        self.change = Change(from: from, to: to, matrix: matrix)
    }
}

public struct Change {
    let from: [Range<Int>]
    let to: [Range<Int>]
    
    init(from: String, to: String, matrix: Matrix) {
        let change = lcs(from: from, to: to, i: from.utf8.count, j: to.utf8.count, matrix: matrix, change: ([], []))
        
        let fromRange: [Range<Int>] = []
        let toRange: [Range<Int>] = []
        
        change.from.reversed().forEach {
            print($0)
        }
        
        change.to.reversed().forEach {
            print($0)
        }
        
        self.from = fromRange
        self.to = toRange
    }
}
