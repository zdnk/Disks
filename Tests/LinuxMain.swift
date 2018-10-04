import XCTest

import vapor_filesystemTests

var tests = [XCTestCaseEntry]()
tests += vapor_filesystemTests.allTests()
XCTMain(tests)