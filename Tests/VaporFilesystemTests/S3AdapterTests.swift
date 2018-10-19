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
        ("testCopyIntegration", testCopyIntegration)
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
            let data = try adapter.read(file: "read_test1.txt", on: container, options: .empty).wait()
            XCTAssertEqual(data.count, testFileSize)
        }
    }
    
    func testSizeIntegration() throws {
        useTestFile("size_test.txt") {
            let size = try adapter.size(of: "size_test.txt", on: container, options: .empty).wait()
            XCTAssertEqual(size, testFileSize)
        }
    }
    
    func testPositiveHasIntegration() throws {
        useTestFile("positive_has_test.txt") {
            let has = try adapter.has(file: "positive_has_test.txt", on: container, options: .empty).wait()
            XCTAssertTrue(has)
        }
    }
    
    func testNegativeHasIntegration() throws {
        let has = try adapter.has(file: "some/fake/file.png", on: container, options: .empty).wait()
        XCTAssertFalse(has)
    }
    
    func testWriteIntegration() throws {
        let file = "write_test.txt"
        
        useTestFile(file) {
            let hasAfter = try adapter.has(file: file, on: container, options: .empty).wait()
            XCTAssertTrue(hasAfter)
        }
    }
    
    func testDeleteIntegration() throws {
        let file = "delete_test.txt"
        
        useTestFile(file) {
            try adapter.delete(file: file, on: container, options: .empty).wait()
            let has = try adapter.has(file: file, on: container, options: .empty).wait()
            XCTAssertFalse(has)
        }
    }
    
    func testCopyIntegration() throws {
        let original = "copy_original_test.txt"
        let destination = "copy_destiatio_test.txt"
        
        useTestFile(original) {
            try adapter.copy(file: original, to: destination, on: container, options: .empty).wait()
            let hasDestination = try adapter.has(file: destination, on: container, options: .empty).wait()
            XCTAssertTrue(hasDestination)
            
            let hasOriginal = try adapter.has(file: original, on: container, options: .empty).wait()
            XCTAssertTrue(hasOriginal)
            
            try adapter.delete(file: destination, on: container, options: .empty).wait()
        }
    }
    
//    func testDirectoryDeleteIntegration() throws {
//        let files = [
//            "delete_dir_test/file1.txt",
//            "delete_dir_test/file2.txt"
//        ]
//
//        try files.forEach(self.deleteTestFile)
//        try files.forEach(self.writeTestFile)
//
//        try files.forEach { (file) in
//            let result = try self.adapter.has(file: file, on: container, options: nil).wait()
//            XCTAssertTrue(result)
//        }
//
//        try adapter.delete(directory: "delete_dir_test/", on: container, options: nil).wait()
//
//        try files.forEach { (file) in
//            let result = try self.adapter.has(file: file, on: container, options: nil).wait()
//            XCTAssertFalse(result)
//        }
//    }
    
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
            bucket: Environment.get("S3_BUCKET")!,
            config: S3Adapter.Config(
                auth: S3Adapter.Auth(
                    accessKey: Environment.get("S3_ACCESS_KEY")!,
                    secretKey: Environment.get("S3_SECRET_KEY")!
                ),
                region: .euCentral1,
                defaultAccess: .privateAccess
            )
        )
    }
    
    fileprivate func writeTestFile(_ path: String) throws {
        try adapter.write(data: testFileData, to: path, on: container, options: .empty).wait()
    }
    
    fileprivate func deleteTestFile(_ path: String) throws {
        let has = try adapter.has(file: path, on: container, options: .empty).wait()
        if has {
            try adapter.delete(file: path, on: container, options: .empty).wait()
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
