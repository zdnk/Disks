import Foundation
import Vapor

extension LocalAdapter: FilesystemReading {
    
    public func has(file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<Bool> {
        return run(on: worker) {
            let path = try self.absolutePath(to: file)
            return self.fileManager.fileExists(atPath: path)
        }
    }
    
    public func read(file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<Data> {
        return run(on: worker) {
            let path = try self.absolutePath(to: file)
            guard let data = self.fileManager.contents(atPath: path) else {
               throw FilesystemError.notFound(path)
            }
            
            return data
        }
    }
    
    public func metadata(of file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<FileMetadataConvertible> {
        return run(on: worker) {
            let path = try self.absolutePath(to: file)
            let attributes = try self.fileManager.attributesOfItem(atPath: path)
            var meta = try attributes.fileMetadata()
            try meta.set(key: .mime, to: self.mediaType(of: file).description)
            return meta
        }
    }
    
    public func size(of file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<Int?> {
        return metadata(of: file, on: worker, options: .empty)
            .map { meta in
                return try meta.fileMetadata().size
        }
    }
    
}
