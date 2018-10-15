import Foundation
import Vapor

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
    
    public func listContents(of: String, recursive: Bool, on: Container, options: FileOptions?) -> EventLoopFuture<[String]> {
        #warning("TODO: list contents support")
        fatalError("Not supported.")
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
    
    public func mimetype(of: String, on: Container, options: FileOptions?) -> EventLoopFuture<String> {
        fatalError("Not supported.")
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
    
    public func write(data: Data, to file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        let path = self.applyPathPrefix(to: file)
        guard self.fileManager.createFile(atPath: path, contents: data, attributes: nil) else {
            return worker.eventLoop.newFailedFuture(error: FilesystemError.creationFailed)
        }
        
        return worker.eventLoop.newSucceededFuture(result: ())
    }
    
    public func update(data: Data, to file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        do {
            let path = self.applyPathPrefix(to: file)
            let fileURL = URL(fileURLWithPath: path)
            
            // Check if file exists
            guard try has(file: file, on: worker, options: options).wait() else {
                throw FilesystemError.fileNotFound(path)
            }
            
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
            return worker.eventLoop.newSucceededFuture(result: ())
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }
    
    public func rename(file: String, to newName: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        do {
            let path = self.applyPathPrefix(to: file)
            let fileURL = URL(fileURLWithPath: path)
            let dir = fileURL.deletingLastPathComponent()
            let newURL = dir.appendingPathComponent(newName, isDirectory: false)
            let newPath = newURL.absoluteString
            try self.fileManager.moveItem(atPath: path, toPath: newPath)
            return worker.eventLoop.newSucceededFuture(result: ())
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }
    
    public func copy(file: String, to newFile: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        do {
            let path = self.applyPathPrefix(to: file)
            let newPath = self.applyPathPrefix(to: file)
            try self.fileManager.copyItem(atPath: path, toPath: newPath)
            return worker.eventLoop.newSucceededFuture(result: ())
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }
    
    public func delete(file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        do {
            let path = self.applyPathPrefix(to: file)
            try self.fileManager.removeItem(atPath: path)
            return worker.eventLoop.newSucceededFuture(result: ())
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }
    
    public func delete(directory: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        do {
            let path = self.applyPathPrefix(to: directory)
            try self.fileManager.removeItem(atPath: path)
            return worker.eventLoop.newSucceededFuture(result: ())
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }
    
    public func create(directory: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        do {
            let path = self.applyPathPrefix(to: directory)
            try self.fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return worker.eventLoop.newSucceededFuture(result: ())
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }
    
}
