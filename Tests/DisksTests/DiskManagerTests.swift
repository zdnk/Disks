import XCTest
import Vapor

@testable import Disks

final class DiskManagerTests: XCTestCase {
    
    static var allTests = [
        ("testUse", testUse),
        ("testDefault", testDefault),
    ]
    
    func testUse() throws {
        let config = LocalAdapter.Config(root: "./")
        let local = LocalAdapter(config: config)
        let manager = try DiskManager(
            config: .init(
                diskMap: [.potatoes: DummyAdapter(), .images: local],
                default: .images
            ),
            on: createContainer()
        )
        
        XCTAssertNoThrow(try manager.use(.images))
        let disk = try manager.use(.images)
        XCTAssertNotNil(disk.filesystem.adapter as? LocalAdapter)
    }
    
    func testDefault() throws {
        let config = LocalAdapter.Config(root: "./")
        let local = LocalAdapter(config: config)
        let dummy = DummyAdapter()
        let manager = try DiskManager(
            config: .init(
                diskMap: [.images: local, .potatoes: dummy],
                default: .potatoes
            ),
            on: createContainer()
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

fileprivate class DummyAdapter: FilesystemAdapting {
    
    var calledHas = false
    
    func has(file: String, on: Container, options: FileOptions) -> EventLoopFuture<Bool> {
        calledHas = true
        return on.eventLoop.newSucceededFuture(result: false)
    }
    
    func read(file: String, on: Container, options: FileOptions) -> EventLoopFuture<Data> {
        fatalError()
    }
    
    func listContents(of: String, recursive: Bool, on: Container, options: FileOptions) -> EventLoopFuture<[String]> {
        fatalError()
    }
    
    func metadata(of: String, on: Container, options: FileOptions) -> EventLoopFuture<FileMetadataConvertible> {
        fatalError()
    }
    
    func size(of: String, on: Container, options: FileOptions) -> EventLoopFuture<Int?> {
        fatalError()
    }
    
    func write(data: Data, to: String, on: Container, options: FileOptions) -> EventLoopFuture<()> {
        fatalError()
    }
    
    func update(data: Data, to: String, on: Container, options: FileOptions) -> EventLoopFuture<()> {
        fatalError()
    }
    
    func move(file: String, to: String, on: Container, options: FileOptions) -> EventLoopFuture<()> {
        fatalError()
    }
    
    func copy(file: String, to: String, on: Container, options: FileOptions) -> EventLoopFuture<()> {
        fatalError()
    }
    
    func delete(file: String, on: Container, options: FileOptions) -> EventLoopFuture<()> {
        fatalError()
    }
    
    func delete(directory: String, on: Container, options: FileOptions) -> EventLoopFuture<()> {
        fatalError()
    }
    
    func create(directory: String, on: Container, options: FileOptions) -> EventLoopFuture<()> {
        fatalError()
    }
    
    
}
