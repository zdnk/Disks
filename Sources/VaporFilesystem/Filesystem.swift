import Foundation
import Vapor

open class Filesystem: FilesystemType {
    
    public let adapter: FilesystemAdapter
    public let worker: Container
    
    public init(adapter: FilesystemAdapter, on worker: Container) {
        self.adapter = adapter
        self.worker = worker
    }
    
}

// Reading
public extension Filesystem {
    
    public func has(file: String, options: FileOptions?) -> Future<Bool> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.has(file: path, on: self.worker, options: options)
            }
    }
    
    public func read(file: String, options: FileOptions?) -> Future<Data> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.read(file: path, on: self.worker, options: options)
            }
    }
    
    public func listContents(of directory: String, recursive: Bool, options: FileOptions?) -> Future<[String]> {
        return Filesystem.normalize(path: directory, on: worker)
            .flatMap { path in
                self.adapter.listContents(of: path, recursive: recursive, on: self.worker, options: options)
            }
    }
    
    public func metadata(of file: String, options: FileOptions?) -> Future<FileMetadata> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.metadata(of: path, on: self.worker, options: options)
            }
    }
    
    public func size(of file: String, options: FileOptions?) -> Future<Int> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.size(of: path, on: self.worker, options: options)
            }
    }
    
    public func mimetype(of file: String, options: FileOptions?) -> Future<String> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.mimetype(of: path, on: self.worker, options: options)
            }
    }
    
    public func timestamp(of file: String, options: FileOptions?) -> Future<Date> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.timestamp(of: path, on: self.worker, options: options)
            }
    }
    
}

// Writing
public extension Filesystem {
    
    public func write(data: Data, to file: String, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.write(data: data, to: path, on: self.worker, options: options)
            }
    }
    
    public func update(data: Data, to file: String, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.update(data: data, to: path, on: self.worker, options: options)
        }
    }
    
    public func put(data: Data, to file: String, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.has(file: path, options: options)
                    .and(result: path)
            }.flatMap { (exists, path) in
                if exists {
                    if self.adapter is FileOverrideSupporting {
                        return self.adapter.update(data: data, to: path, on: self.worker, options: options)
                    }
                    
                    throw FilesystemError.noFileOverrideSupport
                }
                
                return self.adapter.write(data: data, to: path, on: self.worker, options: options)
            }
    }
    
    public func rename(file: String, to newFile: String, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: file, on: worker)
            .and(Filesystem.normalize(path: newFile, on: worker))
            .flatMap { (path, newPath) in
                self.adapter.rename(file: path, to: newPath, on: self.worker, options: options)
            }
    }
    
    public func copy(file: String, to newFile: String, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: file, on: worker)
            .and(Filesystem.normalize(path: newFile, on: worker))
            .flatMap { (path, newPath) in
                self.adapter.copy(file: path, to: newPath, on: self.worker, options: options)
            }
    }
    
    public func delete(file: String, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.delete(file: path, on: self.worker, options: options)
            }
    }
    
    public func delete(directory: String, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: directory, on: worker)
            .map { path in
                if path == "" {
                    throw FilesystemError.rootViolation
                }
                
                return path
            }.flatMap { path in
                self.adapter.delete(directory: path, on: self.worker, options: options)
            }
    }
    
    public func create(directory: String, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: directory, on: worker)
            .flatMap { path in
                self.adapter.create(directory: path, on: self.worker, options: options)
            }
    }
    
}
