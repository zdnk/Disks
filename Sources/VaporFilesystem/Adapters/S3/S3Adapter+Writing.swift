import Foundation
import Vapor

extension S3Adapter: FilesystemWriting {
    
    public func write(data: Data, to: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        return run(path: to, on: worker) {
            #warning("FIXME: access")
            #warning("FIXME: Region is not passed anywhere to upload!")
            let upload = File.Upload(
                data: data,
                bucket: $0.bucket,
                destination: $0.path,
                access: .privateAccess,
                mime: try self.mediaType(of: to).description
            )
            
            return self.has(file: to, on: worker, options: options)
                .flatMap { has -> Future<()> in
                    guard !has else {
                        throw FilesystemError.alreadyExists
                    }
                    
                    return try self.client.put(file: upload, on: worker)
                        .transform(to: ())
                }
        }
    }
    
    public func update(data: Data, to: String, on: Container, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError()
    }
    
    public func rename(file: String, to: String, on: Container, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError()
    }
    
    public func copy(file: String, to: String, on: Container, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError()
    }
    
    public func delete(file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        return run(path: file, on: worker) {
            return try self.client.delete(file: $0, on: worker)
                .transform(to: ())
        }
    }
    
    public func delete(directory: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError("Not supported at the moment.")
    }
    
    public func create(directory: String, on: Container, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError()
    }
    
    
    
    
}
