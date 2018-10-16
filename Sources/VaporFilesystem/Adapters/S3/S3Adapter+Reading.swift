import Foundation
import Vapor
import S3

extension S3Adapter: FilesystemReading {
    
    
    public func has(file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Bool> {
        return run(path: file, on: worker) {
            return try self.client.get(fileInfo: $0, on: worker)
                .transform(to: true)
        }.catchMap{ (error) -> (Bool) in
            if case FilesystemError.notFound = error {
                return false
            }
            
            throw error
        }
    }
    
    public func metadata(of: String, on: Container, options: FileOptions?) -> EventLoopFuture<FileMetadata> {
        fatalError()
    }
    
    public func size(of file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Int> {
        return run(path: file, on: worker) {
            return try self.client.get(fileInfo: $0, on: worker)
                .map { $0.size }
                .unwrap(or: FilesystemError.fileSizeNotAvailable)
        }
    }
    
    public func timestamp(of file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Date> {
        return run(path: file, on: worker) {
            return try self.client.get(fileInfo: $0, on: worker)
                .map { $0.created }
                .unwrap(or: FilesystemError.timestampNotAvailable)
        }
    }
    
    public func read(file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Data> {
        return run(path: file, on: worker) {
            return try self.client
                .get(file: $0, on: worker)
                .map { $0.data }
        }
    }
    
}
