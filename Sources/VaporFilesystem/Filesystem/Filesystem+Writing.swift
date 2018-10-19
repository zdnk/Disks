import Foundation
import Vapor

public extension Filesystem {
    
    public func write(data: Data, to file: String, options: FileOptionsConvertible?) -> Future<()> {
        return normalize(path: file, on: worker)
            .flatMap { path in
                try self.adapter.write(data: data, to: path, on: self.worker, options: options?.fileOptions())
        }
    }
    
    public func update(data: Data, to file: String, options: FileOptionsConvertible?) -> Future<()> {
        return normalize(path: file, on: worker)
            .flatMap { path in
                try self.adapter.update(data: data, to: path, on: self.worker, options: options?.fileOptions())
        }
    }
    
    public func put(data: Data, to file: String, options: FileOptionsConvertible?) -> Future<()> {
        return normalize(path: file, on: worker)
            .flatMap { path in
                self.has(file: path, options: options)
                    .and(result: path)
            }.flatMap { (exists, path) in
                if exists {
                    if self.adapter is FileOverwriteSupporting {
                        return try self.adapter.update(data: data, to: path, on: self.worker, options: options?.fileOptions())
                    }
                    
                    throw FilesystemError.noFileOverrideSupport
                }
                
                return try self.adapter.write(data: data, to: path, on: self.worker, options: options?.fileOptions())
        }
    }
    
    public func move(file: String, to newFile: String, options: FileOptionsConvertible?) -> Future<()> {
        return normalize(path: file, on: worker)
            .and(normalize(path: newFile, on: worker))
            .flatMap { (path, newPath) in
                try self.adapter.move(file: path, to: newPath, on: self.worker, options: options?.fileOptions())
        }
    }
    
    public func copy(file: String, to newFile: String, options: FileOptionsConvertible?) -> Future<()> {
        return normalize(path: file, on: worker)
            .and(normalize(path: newFile, on: worker))
            .flatMap { (path, newPath) in
                try self.adapter.copy(file: path, to: newPath, on: self.worker, options: options?.fileOptions())
        }
    }
    
    public func delete(file: String, options: FileOptionsConvertible?) -> Future<()> {
        return normalize(path: file, on: worker)
            .flatMap { path in
                try self.adapter.delete(file: path, on: self.worker, options: options?.fileOptions())
        }
    }
    
    public func delete(directory: String, options: FileOptionsConvertible?) -> Future<()> {
        return normalize(path: directory, on: worker)
            .map { path in
                if path == "" {
                    throw FilesystemError.rootViolation
                }
                
                return path
            }.flatMap { path in
                try self.adapter.delete(directory: path, on: self.worker, options: options?.fileOptions())
        }
    }
    
    public func create(directory: String, options: FileOptionsConvertible?) -> Future<()> {
        return normalize(path: directory, on: worker)
            .flatMap { path in
                try self.adapter.create(directory: path, on: self.worker, options: options?.fileOptions())
        }
    }
    
}
