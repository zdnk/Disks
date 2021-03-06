import Foundation
import Vapor

extension Filesystem {
    
    public func has(file: String, options: FileOptionsConvertible?) -> Future<Bool> {
        return PathTools.normalize(path: file, on: worker)
            .flatMap { path in
                try self.adapter.has(
                    file: path,
                    on: self.worker,
                    options: options?.fileOptions() ?? .empty
                )
        }
    }
    
    public func read(file: String, options: FileOptionsConvertible?) -> Future<Data> {
        return PathTools.normalize(path: file, on: worker)
            .flatMap { path in
                try self.adapter.read(
                    file: path,
                    on: self.worker,
                    options: options?.fileOptions() ?? .empty
                )
        }
    }
    
    public func listContents(of directory: String, recursive: Bool, options: FileOptionsConvertible?) -> Future<[String]> {
        guard let adapter = self.adapter as? FilesystemContentListing else {
            return worker.eventLoop.newFailedFuture(
                error: FilesystemError.listingUnsupported(by: self.adapter)
            )
        }
        
        return PathTools.normalize(path: directory, on: worker)
            .flatMap { path in
                try adapter.listContents(
                    of: path,
                    recursive: recursive,
                    on: self.worker,
                    options: options?.fileOptions() ?? .empty
                )
        }
    }
    
    public func metadata(of file: String, options: FileOptionsConvertible?) -> Future<FileMetadata> {
        return PathTools.normalize(path: file, on: worker)
            .flatMap { path in
                try self.adapter.metadata(
                    of: path,
                    on: self.worker,
                    options: options?.fileOptions() ?? .empty
                )
            }.map { try $0.fileMetadata() }
    }
    
    public func size(of file: String, options: FileOptionsConvertible?) -> Future<Int?> {
        return PathTools.normalize(path: file, on: worker)
            .flatMap { path in
                try self.adapter.size(
                    of: path,
                    on: self.worker,
                    options: options?.fileOptions() ?? .empty
                )
        }
    }
    
}
