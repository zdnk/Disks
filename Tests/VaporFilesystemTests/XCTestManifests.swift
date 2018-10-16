import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FilesystemManagerTests.allTests),
        testCsse(S3AdapterTests.allTests),
    ]
}
#endif
