import Foundation
import Vapor

extension LocalAdapter: FilesystemReading {
    
    public func has(file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Bool> {
        return run(on: worker) {
            let path = self.applyPathPrefix(to: file)
            return self.fileManager.fileExists(atPath: path)
        }
    }
    
    public func read(file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Data> {
        return run(on: worker) {
            let path = self.applyPathPrefix(to: file)
            guard let data = self.fileManager.contents(atPath: path) else {
               throw FilesystemError.fileNotFound(path)
            }
            
            return data
        }
    }
    
    public func metadata(of file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<FileMetadata> {
        return run(on: worker) {
            let path = self.applyPathPrefix(to: file)
            let attributes = try self.fileManager.attributesOfItem(atPath: path)
            var meta: FileMetadata = [:]
            
            for (key, value) in attributes {
                switch key {
                case .creationDate:
                    meta[.creationDate] = value
                    
                case .modificationDate:
                    meta[.modificationDate] = value
                    
                case .size:
                    meta[.size] = value as? Int
                    
                default: break
                }
            }
            
            return meta
        }
    }
    
    public func size(of file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Int> {
        return metadata(of: file, on: worker, options: nil)
            .map { meta in
                guard let size = meta[.size] as? Int else {
                    throw FilesystemError.fileSizeNotAvailable
                }
                
                return size
        }
    }
    
    public func timestamp(of file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Date> {
        return metadata(of: file, on: worker, options: nil)
            .map { meta in
                guard let date = meta[.modificationDate] as? Date else {
                    throw FilesystemError.timestampNotAvailable
                }
                
                return date
        }
    }
    
}
