import Foundation
import Vapor

open class NullAdapter {
    
    public init() {}
    
}

extension NullAdapter: FilesystemReading {
    
    public func read(file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Data> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.fileNotFound(file))
    }
    
    public func metadata(of file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<FileMetadata> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.fileNotFound(file))
    }
    
    public func size(of file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Int> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.fileNotFound(file))
    }
    
    public func timestamp(of file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Date> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.fileNotFound(file))
    }
    
    
    public func has(file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Bool> {
        return worker.eventLoop.newSucceededFuture(result: false)
    }
    
}

extension NullAdapter: FilesystemWriting {
    
    public func write(data: Data, to: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        #warning("TODO: return the passed data")
        return worker.eventLoop.newSucceededFuture(result: ())
    }
    
    public func update(data: Data, to file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.fileNotFound(file))
    }
    
    public func rename(file: String, to: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.fileNotFound(file))
    }
    
    public func copy(file: String, to: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.fileNotFound(file))
    }
    
    public func delete(file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.fileNotFound(file))
    }
    
    public func delete(directory: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.newFailedFuture(error: FilesystemError.directoryNotFound(directory))
    }
    
    public func create(directory: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        #warning("TODO: return the passed data")
        return worker.eventLoop.newSucceededFuture(result: ())
    }
    
}