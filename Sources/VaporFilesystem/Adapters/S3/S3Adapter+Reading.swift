import Foundation
import Vapor
import S3

extension S3Adapter: FilesystemReading {
    
    
    public func has(file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<Bool> {
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
    
    public func metadata(of file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<FileMetadataConvertible> {
        return run(path: file, on: worker) {
            return try self.client.get(fileInfo: $0, on: worker)
                .map { $0 }
        }
    }
    
    public func size(of file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<Int> {
        return run(path: file, on: worker) {
            return try self.client.get(fileInfo: $0, on: worker)
                .map { $0.size }
                .unwrap(or: FilesystemError.fileSizeNotAvailable)
        }
    }
    
    public func read(file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<Data> {
        return run(path: file, on: worker) {
            return try self.client
                .get(file: $0, on: worker)
                .map { $0.data }
        }
    }
    
}
