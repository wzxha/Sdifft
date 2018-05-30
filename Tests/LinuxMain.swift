import XCTest
@testable import DiffTests

XCTMain([
    testCase(DiffTests.allTests),
    testCase(NSAttributedStringDiffTests.allTests)
])
