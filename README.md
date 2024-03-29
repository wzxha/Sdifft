# Sdifft
![swift version](https://img.shields.io/badge/Language-Swift5-blue.svg)
[![travis-ci](https://travis-ci.org/wzxjiang/Sdifft.svg?branch=master)](https://travis-ci.org/wzxjiang/Sdifft)
[![codecov](https://codecov.io/gh/wzxjiang/Sdifft/branch/master/graph/badge.svg)](https://codecov.io/gh/wzxjiang/Sdifft)
[![codebeat badge](https://codebeat.co/badges/7bf0ffc6-ff68-40b9-aa0f-a6de312d126e)](https://codebeat.co/projects/github-com-wzxjiang-sdifft-master)

Using [`the Myers's Difference Algorithm`](http://www.xmailserver.org/diff2.pdf) to compare differences between two equatable element

## Example(String)

```swift
import Sdifft

let source = "b"
let target = "abcd"
let diff = Diff(source: from, target: to)
diff.scripts // [.insert(into: 3), .insert(into: 2), .same(into: 1), .insert(into: 0)]

/// Get diff attributedString
let diffAttributes = 
    DiffAttributes(
        insert: [.backgroundColor: UIColor.green], 
        delete: [.backgroundColor: UIColor.red], 
        same: [.backgroundColor: UIColor.white]
    )
let attributedString = NSAttributedString(source: source, target: target, attributes: diffAttributes) 

// output ->
// a{green}b{black}cd{green}
```

## Example(Line)

```swift
import Sdifft
let source = ["Hello"]
let target = ["Hello", "World", "!"]
let attributedString = 
    NSAttributedString(source: source, target: target, attributes: diffAttributes) { script, string in
        let string = NSMutableAttributedString(attributedString: string)
        string.append(NSAttributedString(string: "\n"))
        switch script {
        case .delete:
            string.insert(NSAttributedString(string: "- "), at: 0)
        case .insert:
            string.insert(NSAttributedString(string: "+ "), at: 0)
        case .same:
            string.insert(NSAttributedString(string: " "), at: 0)
        }
        return string
    }

// output ->
//    Hello 
//  + World{green}
//  + !{green}
```

## Installation

### Swift Package Manager

```swift
// Package.swift
let package = Package(
    name: "XXX",
    dependencies: [
        .Package(url: "https://github.com/Wzxhaha/Sdifft", majorVersion: 2)
    ]
)
```

### Carthage

```swift
// Cartfile
github "Wzxhaha/Sdifft"
```

## License
Sdifft is released under the MIT license. See LICENSE for details.
