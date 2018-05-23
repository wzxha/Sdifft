# Diff
![swift version](https://img.shields.io/badge/Language-Swift4-blue.svg)
[![travis-ci](https://travis-ci.org/Wzxhaha/Diff.svg?branch=master)](https://travis-ci.org/Wzxhaha/Diff)

Using the LCS to compare differences between two strings

## Example
```swift
let a = "abcd"
let b = "b"
let diff = Diff(from: a, to: b)
diff.modification.add // [0...0, 2...3]
diff.modification.delete // []
diff.modification.same // [1...1]
```

```swift
let a = "abcd"
let b = "bx"
let diff = Diff(from: a, to: b)
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
        .Package(url: "https://github.com/Wzxhaha/Diff", majorVersion: 1)
    ]
)
```

### Carthage

Cartfile
```
github "Wzxhaha/Diff"
```

## License
Diff is released under the MIT license. See LICENSE for details.
