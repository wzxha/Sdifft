# Sdifft
![swift version](https://img.shields.io/badge/Language-Swift4-blue.svg)
[![travis-ci](https://travis-ci.org/Wzxhaha/Sdifft.svg?branch=master)](https://travis-ci.org/Wzxhaha/Sdifft)
[![codecov](https://codecov.io/gh/Wzxhaha/Sdifft/branch/master/graph/badge.svg)](https://codecov.io/gh/Wzxhaha/Sdifft)
[![codebeat badge](https://codebeat.co/badges/d37a19b5-3d38-45ae-a7c5-5e453826188d)](https://codebeat.co/projects/github-com-wzxhaha-sdifft-master)

Using [`the Myers's Difference Algorithm`](http://www.xmailserver.org/diff2.pdf) to compare differences between two equatable element

## Example(String)

```swift
impoort Sdifft

let source = "b"
let target = "abcd"
let diff = Diff(source: from, target: to)
diff.scripts // [.insert(into: 3), .insert(into: 2), .same(into: 1), .insert(into: 0)]

/// Get diff attributedString
let diffAttributes = 
    DiffAttributes(
        insert: [.backgroundColor: UIColor.green]], 
        delete: [.backgroundColor: UIColor.red], 
        same: [.backgroundColor: UIColor.white]
    )
let attributedString = NSAttributedString(source: source, target: target, attributes: diffAttributes) 

// output ->
// a{green}b{black}cd{green}
```

## Example(Line)

```swift
impoort Sdifft
let source = ["Hello"]
let target = ["Hello", "World", "!"]
let attributedString = 
    NSAttributedString(source: source, target: target, attributes: diffAttributes) {
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
        .Package(url: "https://github.com/Wzxhaha/Sdifft", majorVersion: 1)
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
