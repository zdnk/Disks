import Foundation

internal protocol FilesystemForwarding: FilesystemOperating {
    
    var filesystem: FilesystemType { get }
    
}

extension FilesystemForwarding {
    
    public func read(file: String, options: FileOptionsConvertible?) -> Future<Data> {
        return self.filesystem.read(file: file, options: options)
    }
    
    public func has(file: String, options: FileOptionsConvertible?) -> EventLoopFuture<Bool> {
        return self.filesystem.has(file: file, options: options)
    }
    
    public func listContents(of: String, recursive: Bool, options: FileOptionsConvertible?) -> EventLoopFuture<[String]> {
        return self.filesystem.listContents(of: of, recursive: recursive, options: options)
    }
    
    public func metadata(of: String, options: FileOptionsConvertible?) -> EventLoopFuture<FileMetadata> {
        return self.filesystem.metadata(of: of, options: options)
    }
    
    public func size(of: String, options: FileOptionsConvertible?) -> EventLoopFuture<Int> {
        return self.filesystem.size(of: of, options: options)
    }
    
    public func write(data: Data, to: String, options: FileOptionsConvertible?) -> EventLoopFuture<()> {
        return self.filesystem.write(data: data, to: to, options: options)
    }
    
    public func update(data: Data, to: String, options: FileOptionsConvertible?) -> EventLoopFuture<()> {
        return self.filesystem.update(data: data, to: to, options: options)
    }
    
    public func put(data: Data, to: String, options: FileOptionsConvertible?) -> EventLoopFuture<()> {
        return self.filesystem.put(data: data, to: to, options: options)
    }
    
    public func move(file: String, to: String, options: FileOptionsConvertible?) -> EventLoopFuture<()> {
        return self.filesystem.move(file: file, to: to, options: options)
    }
    
    public func rename(file: String, to: String, options: FileOptionsConvertible?) -> Future<()> {
        return self.filesystem.rename(file: file, to: to, options: options)
    }
    
    public func copy(file: String, to: String, options: FileOptionsConvertible?) -> EventLoopFuture<()> {
        return self.filesystem.copy(file: file, to: to, options: options)
    }
    
    public func delete(file: String, options: FileOptionsConvertible?) -> EventLoopFuture<()> {
        return self.filesystem.delete(file: file, options: options)
    }
    
    public func delete(directory: String, options: FileOptionsConvertible?) -> EventLoopFuture<()> {
        return self.filesystem.delete(directory: directory, options: options)
    }
    
    public func create(directory: String, options: FileOptionsConvertible?) -> EventLoopFuture<()> {
        return self.filesystem.create(directory: directory, options: options)
    }
    
}
