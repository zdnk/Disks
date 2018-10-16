import Foundation
import Vapor

extension LocalAdapter: FilesystemReading {
    
    public func has(file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Bool> {
        return run(on: worker) {
            let path = self.absolutePath(to: file)
            return self.fileManager.fileExists(atPath: path)
        }
    }
    
    public func read(file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Data> {
        return run(on: worker) {
            let path = self.absolutePath(to: file)
            guard let data = self.fileManager.contents(atPath: path) else {
               throw FilesystemError.notFound
            }
            
            return data
        }
    }
    
    public func metadata(of file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<FileMetadata> {
        return run(on: worker) {
            let path = self.absolutePath(to: file)
            let attributes = try self.fileManager.attributesOfItem(atPath: path)
            var meta: FileMetadata = FileMetadata()
            
            for (key, value) in attributes {
                switch key {
                case .creationDate:
                    meta.set(key: .creationDate, to: value)
                    
                case .modificationDate:
                    meta.set(key: .modificationDate, to: value)
                    
                case .size:
                    meta.set(key: .size, to: value as? Int)
                    
                default: break
                }
            }
            
            return meta
        }
    }
    
    public func size(of file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Int> {
        return metadata(of: file, on: worker, options: nil)
            .map { meta in
                guard let size = try meta.get(.size, as: Int.self) else {
                    throw FilesystemError.fileSizeNotAvailable
                }
                
                return size
        }
    }
    
    public func timestamp(of file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Date> {
        return metadata(of: file, on: worker, options: nil)
            .map { meta in
                guard let date = try meta.get(.modificationDate, as: Date.self) else {
                    throw FilesystemError.timestampNotAvailable
                }
                
                return date
        }
    }
    
}
