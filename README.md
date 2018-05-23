# Sdifft
![swift version](https://img.shields.io/badge/Language-Swift4-blue.svg)
[![travis-ci](https://travis-ci.org/Wzxhaha/Diff.svg?branch=master)](https://travis-ci.org/Wzxhaha/Diff)
[![codecov](https://codecov.io/gh/Wzxhaha/Diff/branch/master/graph/badge.svg)](https://codecov.io/gh/Wzxhaha/Diff)

Using the LCS to compare differences between two strings

## Example
```swift
let to = "abcd"
let from = "b"
let diff = Diff(from: from, to: to)
diff.modification.add // [0...0, 2...3]
diff.modification.delete // []
diff.modification.same // [1...1]
```

```swift
let to = "abcd"
let from = "bx"
let diff = Diff(from: from, to: to)
diff.modification.add // [0...0, 2...3]
diff.modification.delete // [1...1]
diff.modification.same // [1...1]
```

## Installation

### Swift Package Manager

Package.swift
```swift
let package = Package(
    name: "XXX",
    dependencies: [
        .Package(url: "https://github.com/Wzxhaha/Sdifft", majorVersion: 1)
    ]
)
```

### Carthage

Cartfile
```
github "Wzxhaha/Sdifft"
```

## License
Diff is released under the MIT license. See LICENSE for details.
