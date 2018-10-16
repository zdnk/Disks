import Foundation
import Vapor

extension S3Adapter: FilesystemWriting {
    
    public func write(data: Data, to: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        return run(file: to, on: worker) {
            guard let mediaType = self.mediaType(of: to) else {
                #warning("FIXME: proper error")
                return worker.eventLoop.newFailedFuture(error: FilesystemError.creationFailed)
            }
            
            #warning("FIXME: access")
            #warning("FIXME: Region is not passed anywhere to upload!")
            let upload = File.Upload(
                data: data,
                bucket: $0.bucket,
                destination: $0.path,
                access: .privateAccess,
                mime: mediaType.description
            )
            
            return self.has(file: to, on: worker, options: options)
                .flatMap { has -> Future<()> in
                    guard !has else {
                        #warning("FIXME: Use proper error")
                        throw FilesystemError.creationFailed
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
        return run(file: file, on: worker) {
            return try self.client.delete(file: $0, on: worker)
                .transform(to: ())
        }
    }
    
    public func delete(directory: String, on: Container, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError()
    }
    
    public func create(directory: String, on: Container, options: FileOptions?) -> EventLoopFuture<()> {
        fatalError()
    }
    
    
    
    
}
