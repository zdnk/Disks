import Foundation
import Vapor

extension Filesystem {
    
    public func has(file: String, options: FileOptions?) -> Future<Bool> {
        return normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.has(file: path, on: self.worker, options: options)
        }
    }
    
    public func read(file: String, options: FileOptions?) -> Future<Data> {
        return normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.read(file: path, on: self.worker, options: options)
        }
    }
    
    public func listContents(of directory: String, recursive: Bool, options: FileOptions?) -> Future<[String]> {
        guard let adapter = self.adapter as? FilesystemContentListing else {
            return worker.eventLoop.newFailedFuture(
                error: FilesystemError.listingUnsupported(by: self.adapter)
            )
        }
        
        return normalize(path: directory, on: worker)
            .flatMap { path in
                adapter.listContents(of: path, recursive: recursive, on: self.worker, options: options)
        }
    }
    
    public func metadata(of file: String, options: FileOptions?) -> Future<FileMetadata> {
        return normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.metadata(of: path, on: self.worker, options: options)
        }
    }
    
    public func size(of file: String, options: FileOptions?) -> Future<Int> {
        return normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.size(of: path, on: self.worker, options: options)
        }
    }
    
    public func timestamp(of file: String, options: FileOptions?) -> Future<Date> {
        return normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.timestamp(of: path, on: self.worker, options: options)
        }
    }
    
}
