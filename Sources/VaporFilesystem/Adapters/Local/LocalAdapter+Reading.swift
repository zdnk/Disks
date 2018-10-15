import Foundation
import Vapor

extension LocalAdapter: FilesystemReading {
    
    public func has(file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Bool> {
        let path = self.applyPathPrefix(to: file)
        let exists = self.fileManager.fileExists(atPath: path)
        return worker.eventLoop.newSucceededFuture(result: exists)
    }
    
    public func read(file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<Data> {
        let path = self.applyPathPrefix(to: file)
        guard let data = self.fileManager.contents(atPath: path) else {
            return worker.eventLoop.newFailedFuture(error: FilesystemError.fileNotFound(path))
        }
        
        return worker.eventLoop.newSucceededFuture(result: data)
    }
    
    public func metadata(of file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<FileMetadata> {
        do {
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
            
            return worker.eventLoop.newSucceededFuture(result: meta)
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
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
