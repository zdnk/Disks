import Foundation
import Vapor

extension S3Adapter: FilesystemWriting, FileOverwriteSupporting {
    
    public func write(data: Data, to: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return run(path: to, on: worker) { file in
            let s3Options = try options.s3()
            let upload = try self.fileUpload(data: data, to: file, options: s3Options)
            
            return self.has(file: file.path, on: worker, options: options)
                .flatMap { has -> Future<()> in
                    guard !has else {
                        throw FilesystemError.alreadyExists(file.path)
                    }
                    
                    return try self.client.put(file: upload, on: worker)
                        .transform(to: ())
                }
        }
    }
    
    public func update(data: Data, to: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return run(path: to, on: worker) { file in
            let s3Options = try options.s3()
            let upload = try self.fileUpload(data: data, to: file, options: s3Options)
            
            return self.has(file: file.path, on: worker, options: options)
                .flatMap { has -> Future<()> in
                    guard has else {
                        throw FilesystemError.notFound(file.path)
                    }
                    
                    return try self.client.put(file: upload, on: worker)
                        .transform(to: ())
            }
        }
    }
    
    public func move(file: String, to: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return self.copy(file: file, to: to, on: worker, options: options)
            .flatMap { (_) in
                return self.delete(file: file, on: worker, options: options)
        }
    }
    
    public func copy(file: String, to: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return run(path: file, on: worker) { origin in
            return run(path: to, on: worker) { destination in
                return try self.client.copy(file: origin, to: destination, on: worker)
                    .transform(to: ())
            }
        }
    }
    
    public func delete(file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return run(path: file, on: worker) {
            return try self.client.delete(file: $0, on: worker)
                .transform(to: ())
        }
    }
    
    public func delete(directory: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        fatalError("Not implemented.")
    }
    
    public func create(directory: String, on: Container, options: FileOptions) -> EventLoopFuture<()> {
        fatalError("Not implemented.")
    }
    
    
    
    
}
