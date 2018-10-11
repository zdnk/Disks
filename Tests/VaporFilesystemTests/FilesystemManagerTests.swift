import XCTest
import Vapor

@testable import VaporFilesystem

final class FilesystemManagerTests: XCTestCase {
    
    static var allTests = [
        ("testUse", testUse),
        ("testDefault", testDefault),
    ]
    
    func testUse() throws {
        let worker = EmbeddedEventLoop()
        
        let local = LocalAdapter(root: "./")
        let manager = try FilesystemManager(
            disks: [.potatoes: DummyAdapter(), .images: local],
            default: .images,
            on: worker
        )
        
        XCTAssertNoThrow(try manager.use(.images))
        let fs = try manager.use(.images)
        XCTAssertNotNil(fs.adapter as? LocalAdapter)
        XCTAssert(fs.adapter as? LocalAdapter === local, "FilesystemManager does not use same instance of adapter")
    }
    
    func testDefault() throws {
        
        let local = LocalAdapter(root: "./")
        let dummy = DummyAdapter()
        let manager = try FilesystemManager(
            disks: [.images: local, .potatoes: dummy],
            default: .potatoes,
            on: EmbeddedEventLoop()
        )

        let result = try manager.has(file: "irelevant").wait()
        XCTAssertTrue(dummy.calledHas)
        XCTAssertFalse(result)
    }
    
}

fileprivate extension  DiskIdentifier {
    
    static var images: DiskIdentifier { return DiskIdentifier("images") }
    static var potatoes: DiskIdentifier { return DiskIdentifier("potatoes") }
    
}

fileprivate class DummyAdapter: FilesystemAdapter {
    
    var calledHas = false
    
    func has(file: String, on: Worker, options: FileOptions?) -> EventLoopFuture<Bool> {
        calledHas = true
        return on.eventLoop.newSucceededFuture(result: false)
    }
    
    func read(file: String, on: Worker, options: FileOptions?) -> EventLoopFuture<Data> {
        fatalError()
    }
    
    func listContents(of: String, recursive: Bool, on: Worker, options: FileOptions?) -> EventLoopFuture<[String]> {
        fatalError()
    }
    
    func metadata(of: String, on: Worker, options: FileOptions?) -> EventLoopFuture<FileMetadata> {
        fatalError()
    }
    
    func size(of: String, on: Worker, options: FileOptions?) -> EventLoopFuture<Int> {
        fatalError()
    }
    
    func mimetype(of: String, on: Worker, options: FileOptions?) -> EventLoopFuture<String> {
        fatalError()
    }
    
    func timestamp(of: String, on: Worker, options: FileOptions?) -> EventLoopFuture<Date> {
        fatalError()
    }
    
    func write(data: Data, to: String, on: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError()
    }
    
    func update(data: Data, to: String, on: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError()
    }
    
    func rename(file: String, to: String, on: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError()
    }
    
    func copy(file: String, to: String, on: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError()
    }
    
    func delete(file: String, on: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError()
    }
    
    func delete(directory: String, on: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError()
    }
    
    func create(directory: String, on: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError()
    }
    
    
}
