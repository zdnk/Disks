import Foundation
import Vapor

extension S3Adapter: FilesystemWriting, FileOverwriteSupporting {
    
    public func write(data: Data, to: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        return run(path: to, on: worker) {
            let upload = try self.fileUpload(data: data, to: $0, options: options)
            
            return self.has(file: $0.path, on: worker, options: options)
                .flatMap { has -> Future<()> in
                    guard !has else {
                        throw FilesystemError.alreadyExists
                    }
                    
                    return try self.client.put(file: upload, on: worker)
                        .transform(to: ())
                }
        }
    }
    
    public func update(data: Data, to: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        return run(path: to, on: worker) {
            let upload = try self.fileUpload(data: data, to: $0, options: options)
            
            return self.has(file: $0.path, on: worker, options: options)
                .flatMap { has -> Future<()> in
                    guard has else {
                        throw FilesystemError.notFound
                    }
                    
                    return try self.client.put(file: upload, on: worker)
                        .transform(to: ())
            }
        }
    }
    
    public func rename(file: String, to: String, on: Container, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError("Not implemented.")
    }
    
    public func copy(file: String, to: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        return run(path: file, on: worker) { origin in
            return run(path: to, on: worker) { destination in
                return try self.client.copy(file: origin, to: destination, on: worker)
                    .transform(to: ())
            }
        }
    }
    
    public func delete(file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        return run(path: file, on: worker) {
            return try self.client.delete(file: $0, on: worker)
                .transform(to: ())
        }
    }
    
    public func delete(directory: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError("Not implemented.")
    }
    
    public func create(directory: String, on: Container, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError("Not implemented.")
    }
    
    
    
    
}
