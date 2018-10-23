import Foundation
import Vapor

extension LocalAdapter: FilesystemWriting {

    public var supportsOverwrite: Bool {
        return true
    }
    
    public func write(data: Data, to file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return run(on: worker) {
            let path = try self.absolutePath(to: file)
            guard self.fileManager.createFile(atPath: path, contents: data, attributes: nil) else {
                throw FilesystemError.creationFailed(path)
            }
            
            return ()
        }
    }

    public func update(data: Data, to file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return run(on: worker) {
            let path = try self.absolutePath(to: file)
            let fileURL = URL(fileURLWithPath: path)
            
            // Check if file exists
            guard try self.has(file: file, on: worker, options: options).wait() else {
                throw FilesystemError.notFound(path)
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
            return ()
        }
    }

    public func move(file: String, to newName: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return run(on: worker) {
            let path = try self.absolutePath(to: file)
            let fileURL = URL(fileURLWithPath: path)
            let dir = fileURL.deletingLastPathComponent()
            let newURL = dir.appendingPathComponent(newName, isDirectory: false)
            let newPath = newURL.absoluteString
            try self.fileManager.moveItem(atPath: path, toPath: newPath)
            return ()
        }
    }

    public func copy(file: String, to newFile: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return run(on: worker) {
            let path = try self.absolutePath(to: file)
            let newPath = try self.absolutePath(to: file)
            try self.fileManager.copyItem(atPath: path, toPath: newPath)
            return ()
        }
    }

    public func delete(file: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return run(on: worker) {
            let path = try self.absolutePath(to: file)
            try self.fileManager.removeItem(atPath: path)
            return ()
        }
    }

    public func delete(directory: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return run(on: worker) {
            let path = try self.absolutePath(to: directory)
            try self.fileManager.removeItem(atPath: path)
            return ()
        }
    }

    public func create(directory: String, on worker: Container, options: FileOptions) -> EventLoopFuture<()> {
        return run(on: worker) {
            let path = try self.absolutePath(to: directory)
            try self.fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return ()
        }
    }

}
