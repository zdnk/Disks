import Foundation
import Vapor

public enum LocalFilesystemError: Error {
    case fileCreationFailed
    case fileUpdateFailed
    case fileNotFound
    case timestampNotAvailable
    case fileSizeNotAvailable
}

public final class LocalAdapter: FilesystemAdapter {
    
    public let fileManager: FileManager
    public let root: String
    
    public init(fileManager: FileManager = .default, root: String) {
        self.fileManager = fileManager
        self.root = root
    }
    
    public func applyPathPrefix(to path: String) -> String {
        let prefixed = Filesystem.applyPathPrefix(self.root, to: path)
        return URL(fileURLWithPath: prefixed).absoluteString
    }
    
    public func has(file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<Bool> {
        return worker.eventLoop.submit { () -> Bool in
            let path = self.applyPathPrefix(to: file)
            return self.fileManager.fileExists(atPath: path)
        }
    }
    
    public func read(file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<Data> {
        return worker.eventLoop.submit { () -> Data in
            let path = self.applyPathPrefix(to: file)
            guard let data = self.fileManager.contents(atPath: path) else {
                throw LocalFilesystemError.fileNotFound
            }
            
            return data
        }
    }
    
    public func listContents(of: String, recursive: Bool, on: Worker, options: FileOptions?) -> EventLoopFuture<[String]> {
        #warning("TODO: list contents support")
        fatalError("Not supported.")
    }
    
    public func metadata(of file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<FileMetadata> {
        return worker.eventLoop.submit { () -> [FileAttributeKey: Any] in
            let path = self.applyPathPrefix(to: file)
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
    
    public func size(of file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<Int> {
        return metadata(of: file, on: worker, options: nil)
            .map { meta in
                guard let size = meta[.size] as? Int else {
                    throw LocalFilesystemError.fileSizeNotAvailable
                }
                
                return size
        }
    }
    
    public func mimetype(of: String, on: Worker, options: FileOptions?) -> EventLoopFuture<String> {
        fatalError("Not supported.")
    }
    
    public func timestamp(of file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<Date> {
        return metadata(of: file, on: worker, options: nil)
            .map { meta in
                guard let date = meta[.modificationDate] as? Date else {
                    throw LocalFilesystemError.timestampNotAvailable
                }
                
                return date
            }
    }
    
    public func visibility(of: String, on: Worker, options: FileOptions?) -> EventLoopFuture<FileVisibility> {
        fatalError("Unsupported")
    }
    
    public func write(data: Data, to file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.submit {
            let path = self.applyPathPrefix(to: file)
            guard self.fileManager.createFile(atPath: path, contents: data, attributes: nil) else {
                throw LocalFilesystemError.fileCreationFailed
            }
        }
    }
    
    public func update(data: Data, to file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.submit {
            let path = self.applyPathPrefix(to: file)
            let fileURL = URL(fileURLWithPath: path)
            
            #warning("TODO: check if file exists")
            
            // Saving to temp file
            let tempUUID = UUID().uuidString
            let tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent(tempUUID)
            
            self.fileManager.createFile(
                atPath: tempURL.absoluteString,
                contents: data,
                attributes: nil
            )
            
            // Replacing old one
            _ = try self.fileManager.replaceItemAt(fileURL, withItemAt: tempURL, backupItemName: nil, options: [])
            
            // Remove temp file
            try self.fileManager.removeItem(at: tempURL)
        }
    }
    
    public func rename(file: String, to newName: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.submit {
            let path = self.applyPathPrefix(to: file)
            let fileURL = URL(fileURLWithPath: path)
            let dir = fileURL.deletingLastPathComponent()
            let newURL = dir.appendingPathComponent(newName, isDirectory: false)
            let newPath = newURL.absoluteString
            try self.fileManager.moveItem(atPath: path, toPath: newPath)
        }
    }
    
    public func copy(file: String, to newFile: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.submit {
            let path = self.applyPathPrefix(to: file)
            let newPath = self.applyPathPrefix(to: file)
            try self.fileManager.copyItem(atPath: path, toPath: newPath)
        }
    }
    
    public func delete(file: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.submit {
            let path = self.applyPathPrefix(to: file)
            try self.fileManager.removeItem(atPath: path)
        }
    }
    
    public func delete(directory: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.submit {
            let path = self.applyPathPrefix(to: directory)
            try self.fileManager.removeItem(atPath: path)
        }
    }
    
    public func create(directory: String, on worker: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        return worker.eventLoop.submit {
            let path = self.applyPathPrefix(to: directory)
            try self.fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    public func setVisibility(of: String, to: FileVisibility, on: Worker, options: FileOptions?) -> EventLoopFuture<()> {
        #warning("TODO: what is visibility actually?")
        fatalError("Unsupported.")
    }
    
}
