import Foundation
import Vapor

enum FilesystemError: Error {
    case cantConstructURLfromPath(String)
    case pathOutsideOfRoot(String)
    case fileNotFound(String)
    case noFileOverrideSupport
    case rootViolation
}

class Filesystem: FilesystemType {
    
    let adapter: FilesystemAdapter
    
    init(adapter: FilesystemAdapter) {
        self.adapter = adapter
    }
    
}

// Reading
extension Filesystem {
    
    func has(file: String, on worker: Worker, options: FileOptions?) -> Future<Bool> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.has(file: path, on: worker, options: options)
            }
    }
    
    func read(file: String, on worker: Worker, options: FileOptions?) -> Future<Data> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.read(file: path, on: worker, options: options)
            }
    }
    
    func listContents(of directory: String, recursive: Bool, on worker: Worker, options: FileOptions?) -> Future<[String]> {
        return Filesystem.normalize(path: directory, on: worker)
            .flatMap { path in
                self.adapter.listContents(of: path, recursive: recursive, on: worker, options: options)
            }
    }
    
    func metadata(of file: String, on worker: Worker, options: FileOptions?) -> Future<FileMetadata> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.metadata(of: path, on: worker, options: options)
            }
    }
    
    func size(of file: String, on worker: Worker, options: FileOptions?) -> Future<Int> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.size(of: path, on: worker, options: options)
            }
    }
    
    func mimetype(of file: String, on worker: Worker, options: FileOptions?) -> Future<String> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.mimetype(of: path, on: worker, options: options)
            }
    }
    
    func timestamp(of file: String, on worker: Worker, options: FileOptions?) -> Future<Date> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.timestamp(of: path, on: worker, options: options)
            }
    }
    
    func visibility(of file: String, on worker: Worker, options: FileOptions?) -> Future<FileVisibility> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.visibility(of: path, on: worker, options: options)
            }
    }
    
}

// Writing
extension Filesystem {
    
    func write(data: Data, to file: String, on worker: Worker, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.write(data: data, to: path, on: worker, options: options)
            }
    }
    
    func update(data: Data, to file: String, on worker: Worker, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.update(data: data, to: path, on: worker, options: options)
        }
    }
    
    func put(data: Data, to file: String, on worker: Worker, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.has(file: path, on: worker, options: options)
                    .and(result: path)
            }.flatMap { (exists, path) in
                if exists {
                    if self.adapter is FileOverrideSupporting {
                        return self.adapter.update(data: data, to: path, on: worker, options: options)
                    }
                    
                    throw FilesystemError.noFileOverrideSupport
                }
                
                return self.adapter.write(data: data, to: path, on: worker, options: options)
            }
    }
    
    func rename(file: String, to newFile: String, on worker: Worker, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: file, on: worker)
            .and(Filesystem.normalize(path: newFile, on: worker))
            .flatMap { (path, newPath) in
                self.adapter.rename(file: path, to: newPath, on: worker, options: options)
            }
    }
    
    func copy(file: String, to newFile: String, on worker: Worker, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: file, on: worker)
            .and(Filesystem.normalize(path: newFile, on: worker))
            .flatMap { (path, newPath) in
                self.adapter.copy(file: path, to: newPath, on: worker, options: options)
            }
    }
    
    func delete(file: String, on worker: Worker, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.delete(file: path, on: worker, options: options)
            }
    }
    
    func delete(directory: String, on worker: Worker, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: directory, on: worker)
            .map { path in
                if path == "" {
                    throw FilesystemError.rootViolation
                }
                
                return path
            }.flatMap { path in
                self.adapter.delete(directory: path, on: worker, options: options)
            }
    }
    
    func create(directory: String, on worker: Worker, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: directory, on: worker)
            .flatMap { path in
                self.adapter.create(directory: path, on: worker, options: options)
            }
    }
    
    func setVisibility(of file: String, to visibility: FileVisibility, on worker: Worker, options: FileOptions?) -> Future<()> {
        return Filesystem.normalize(path: file, on: worker)
            .flatMap { path in
                self.adapter.setVisibility(of: path, to: visibility, on: worker, options: options)
            }
    }
    
}
