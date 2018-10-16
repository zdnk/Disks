import Foundation
import XCTest

@testable import VaporFilesystem

final class S3AdapterTests: XCTestCase {
    
    static var allTests = [
        ("testReadIntegration", testReadIntegration),
        ("testSizeIntegration", testSizeIntegration),
        ("testPositiveHasIntegration", testPositiveHasIntegration),
        ("testNegativeHasIntegration", testNegativeHasIntegration),
        ("testWriteIntegration", testWriteIntegration),
        ("testDeleteIntegration", testDeleteIntegration),
    ]
    
    var container: Container!
    var adapter: S3Adapter!
    
    override func setUp() {
        self.container = createContainer()
        self.adapter = try! createAdapter()
        
        super.setUp()
    }
    
    func testReadIntegration() throws {
        useTestFile("read_test1.txt") {
            let data = try adapter.read(file: "read_test1.txt", on: container, options: nil).wait()
            XCTAssertEqual(data.count, testFileSize)
        }
    }
    
    func testSizeIntegration() throws {
        useTestFile("size_test.txt") {
            let size = try adapter.size(of: "size_test.txt", on: container, options: nil).wait()
            XCTAssertEqual(size, testFileSize)
        }
    }
    
    func testPositiveHasIntegration() throws {
        useTestFile("positive_has_test.txt") {
            let has = try adapter.has(file: "positive_has_test.txt", on: container, options: nil).wait()
            XCTAssertTrue(has)
        }
    }
    
    func testNegativeHasIntegration() throws {
        let has = try adapter.has(file: "some/fake/file.png", on: container, options: nil).wait()
        XCTAssertFalse(has)
    }
    
    func testWriteIntegration() throws {
        let file = "write_test.txt"
        
        useTestFile(file) {
            let hasAfter = try adapter.has(file: file, on: container, options: nil).wait()
            XCTAssertTrue(hasAfter)
        }
    }
    
    func testDeleteIntegration() throws {
        let file = "delete_test.txt"
        
        useTestFile(file) {
            try adapter.delete(file: file, on: container, options: nil).wait()
            let has = try adapter.has(file: file, on: container, options: nil).wait()
            XCTAssertFalse(has)
        }
    }
    
}

fileprivate extension S3AdapterTests {
    
    var testFileSize: Int {
        return testFileData.count
    }
    
    var testFileData: Data {
        return "hello world".data(using: .utf8)!
    }
    
    func createAdapter() throws -> S3Adapter {
        return try S3Adapter(
            bucket: "<your-bucket>",
            config: S3Signer.Config(
                accessKey: "<your-accessKey>",
                secretKey: "<your-secretKey>",
                region: .euCentral1 // your region
            )
        )
    }
    
    fileprivate func writeTestFile(_ path: String) throws {
        try adapter.write(data: testFileData, to: path, on: container, options: nil).wait()
    }
    
    fileprivate func deleteTestFile(_ path: String) throws {
        let has = try adapter.has(file: path, on: container, options: nil).wait()
        if has {
            try adapter.delete(file: path, on: container, options: nil).wait()
        }
    }
    
    fileprivate func useTestFile(_ path: String, _ closure: () throws -> ()) {
        try? deleteTestFile(path)
        
        do {
            try writeTestFile(path)
        }
        catch {
            try? deleteTestFile(path)
            XCTFail("Failed preparing file \(path): \(error)")
        }
        
        do {
            try closure()
        } catch {
            XCTFail("Failed on \(path): \(error)")
        }
        
        do {
            try deleteTestFile(path)
        } catch {
            XCTFail("Failed removing file \(path): \(error)")
        }
    }
    
}
