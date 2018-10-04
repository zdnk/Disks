import Foundation
import Vapor

enum LocalFilesystemError: Error {
    case fileCreationFailed
    case fileUpdateFailed
    case fileNotFound
    case timestampNotAvailable
    case fileSizeNotAvailable
}

final class LocalAdapter: FilesystemAdapter {
    
    let fileManager: FileManager
    let root: String
    
    init(fileManager: FileManager = .default, root: String) {
        self.fileManager = fileManager
        self.root = root
    }
    
    func has(file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<Bool> {
        return worker.eventLoop.submit { () -> Bool in
            let path = Filesystem.applyPathPrefix(self.root, to: file)
            return self.fileManager.fileExists(atPath: path)
        }
    }
    
    func read(file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<Data> {
        return worker.eventLoop.submit { () -> Data in
            let path = Filesystem.applyPathPrefix(self.root, to: file)
            guard let data = self.fileManager.contents(atPath: path) else {
                throw LocalFilesystemError.fileNotFound
            }
            
            return data
        }
    }
    
    func listContents(of: String, recursive: Bool, on: Worker, options: FileOptions?) -> EventLoopFuture<[String]> {
        #warning("TODO: list contents support")
        fatalError("Not supported.")
    }
    
    func metadata(of file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<FileMetadata> {
        return worker.eventLoop.submit { () -> [FileAttributeKey: Any] in
            let path = Filesystem.applyPathPrefix(self.root, to: file)
            return try self.fileManager.attributesOfItem(atPath: path)
            }.map { attributes -> FileMetadata in
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
    
    func size(of file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<Int> {
        return metadata(of: file, on: worker, options: nil)
            .map { meta in
                guard let size = meta[.size] as? Int else {
                    throw LocalFilesystemError.fileSizeNotAvailable
                }
                
                return size
        }
    }
    
    func mimetype(of: String, on: Worker, options: FileOptions?) -> EventLoopFuture<String> {
        fatalError("Not supported.")
    }
    
    func timestamp(of file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<Date> {
        return metadata(of: file, on: worker, options: nil)
            .map { meta in
                guard let date = meta[.modificationDate] as? Date else {
                    throw LocalFilesystemError.timestampNotAvailable
                }
                
                return date
            }
    }
    
    func visibility(of: String, on: Worker, options: FileOptions?) -> EventLoopFuture<FileVisibility> {
        fatalError("Unsupported")
    }
    
    func write(data: Data, to file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.submit {
            let path = Filesystem.applyPathPrefix(self.root, to: file)
            guard self.fileManager.createFile(atPath: path, contents: data, attributes: nil) else {
                throw LocalFilesystemError.fileCreationFailed
            }
        }
    }
    
    func update(data: Data, to file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.submit {
            let path = Filesystem.applyPathPrefix(self.root, to: file)
            try self.fileManager.removeItem(atPath: path)
            guard self.fileManager.createFile(atPath: file, contents: data, attributes: nil) else {
                throw LocalFilesystemError.fileUpdateFailed
            }
        }
    }
    
    func rename(file: String, to newFile: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.submit {
            let path = Filesystem.applyPathPrefix(self.root, to: file)
            let newPath = Filesystem.applyPathPrefix(self.root, to: newFile)
            try self.fileManager.moveItem(atPath: path, toPath: newPath)
        }
    }
    
    func copy(file: String, to newFile: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.submit {
            let path = Filesystem.applyPathPrefix(self.root, to: file)
            let newPath = Filesystem.applyPathPrefix(self.root, to: newFile)
            try self.fileManager.copyItem(atPath: path, toPath: newPath)
        }
    }
    
    func delete(file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.submit {
            let path = Filesystem.applyPathPrefix(self.root, to: file)
            try self.fileManager.removeItem(atPath: path)
        }
    }
    
    func delete(directory: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.submit {
            let path = Filesystem.applyPathPrefix(self.root, to: directory)
            try self.fileManager.removeItem(atPath: path)
        }
    }
    
    func create(directory: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.submit {
            let path = Filesystem.applyPathPrefix(self.root, to: directory)
            try self.fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func setVisibility(of: String, to: FileVisibility, on: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        #warning("TODO: what is visibility actually?")
        fatalError("Unsupported.")
    }
    
}
