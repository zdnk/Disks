import Foundation
import Vapor

extension LocalAdapter: FilesystemWriting {

    open func write(data: Data, to file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        let path = self.applyPathPrefix(to: file)
        guard self.fileManager.createFile(atPath: path, contents: data, attributes: nil) else {
            return worker.eventLoop.newFailedFuture(error: FilesystemError.creationFailed)
        }
        
        return worker.eventLoop.newSucceededFuture(result: ())
    }

    open func update(data: Data, to file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
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

    open func rename(file: String, to newName: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
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

    open func copy(file: String, to newFile: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        do {
            let path = self.applyPathPrefix(to: file)
            let newPath = self.applyPathPrefix(to: file)
            try self.fileManager.copyItem(atPath: path, toPath: newPath)
            return worker.eventLoop.newSucceededFuture(result: ())
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }

    open func delete(file: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        do {
            let path = self.applyPathPrefix(to: file)
            try self.fileManager.removeItem(atPath: path)
            return worker.eventLoop.newSucceededFuture(result: ())
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }

    open func delete(directory: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        do {
            let path = self.applyPathPrefix(to: directory)
            try self.fileManager.removeItem(atPath: path)
            return worker.eventLoop.newSucceededFuture(result: ())
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }

    open func create(directory: String, on worker: Container, options: FileOptions?) -> EventLoopFuture<()> {
        do {
            let path = self.applyPathPrefix(to: directory)
            try self.fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return worker.eventLoop.newSucceededFuture(result: ())
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }

}
