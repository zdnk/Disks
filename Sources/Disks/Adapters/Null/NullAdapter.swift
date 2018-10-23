import Foundation
import Vapor

public struct NullAdapter {
    
    public init() {}
    
}

extension NullAdapter: FilesystemReading {
    
    public func read(file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<Data> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.notFound(file))
    }
    
    public func metadata(of file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<FileMetadataConvertible> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.notFound(file))
    }
    
    public func size(of file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<Int?> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.notFound(file))
    }
    
    public func timestamp(of file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<Date> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.notFound(file))
    }
    
    
    public func has(file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<Bool> {
        return worker.eventLoop.newSucceededFuture(result: false)
    }
    
}

extension NullAdapter: FilesystemWriting {
    
    public var supportsOverwrite: Bool {
        return true
    }
    
    public func write(data: Data, to: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        #warning("TODO: return the passed data")
        return worker.eventLoop.newSucceededFuture(result: ())
    }
    
    public func update(data: Data, to file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.notFound(file))
    }
    
    public func move(file: String, to: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.notFound(file))
    }
    
    public func copy(file: String, to: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.notFound(file))
    }
    
    public func delete(file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.notFound(file))
    }
    
    public func delete(directory: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.notFound(directory))
    }
    
    public func create(directory: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        #warning("TODO: return the passed data")
        return worker.eventLoop.newSucceededFuture(result: ())
    }
    
}
