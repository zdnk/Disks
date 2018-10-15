import Foundation
import Vapor

public extension Filesystem {
    
    public func write(data: Data, to file: String, options: FileOptions?) -> Future<()> {
        return normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.write(data: data, to: path, on: self.worker, options: options)
        }
    }
    
    public func update(data: Data, to file: String, options: FileOptions?) -> Future<()> {
        return normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.update(data: data, to: path, on: self.worker, options: options)
        }
    }
    
    public func put(data: Data, to file: String, options: FileOptions?) -> Future<()> {
        return normalize(path: file, on: worker)
            .flatMap { path in
                self.has(file: path, options: options)
                    .and(result: path)
            }.flatMap { (exists, path) in
                if exists {
                    if self.adapter is FileOverwriteSupporting {
                        return self.adapter.update(data: data, to: path, on: self.worker, options: options)
                    }
                    
                    throw FilesystemError.noFileOverrideSupport
                }
                
                return self.adapter.write(data: data, to: path, on: self.worker, options: options)
        }
    }
    
    public func rename(file: String, to newFile: String, options: FileOptions?) -> Future<()> {
        return normalize(path: file, on: worker)
            .and(normalize(path: newFile, on: worker))
            .flatMap { (path, newPath) in
                self.adapter.rename(file: path, to: newPath, on: self.worker, options: options)
        }
    }
    
    public func copy(file: String, to newFile: String, options: FileOptions?) -> Future<()> {
        return normalize(path: file, on: worker)
            .and(normalize(path: newFile, on: worker))
            .flatMap { (path, newPath) in
                self.adapter.copy(file: path, to: newPath, on: self.worker, options: options)
        }
    }
    
    public func delete(file: String, options: FileOptions?) -> Future<()> {
        return normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.delete(file: path, on: self.worker, options: options)
        }
    }
    
    public func delete(directory: String, options: FileOptions?) -> Future<()> {
        return normalize(path: directory, on: worker)
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
        return normalize(path: directory, on: worker)
            .flatMap { path in
                self.adapter.create(directory: path, on: self.worker, options: options)
        }
    }
    
}
