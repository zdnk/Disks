import Foundation
import Vapor

public protocol FileOverwriteSupporting { }

public protocol FilesystemContentListing {
    
    func listContents(of: String, recursive: Bool, on: Container, options: FileOptions?) -> Future<[String]>
    
}

public protocol FilesystemReading {
    
    func has(file: String, on: Container, options: FileOptions?) -> Future<Bool>
    func read(file: String, on: Container, options: FileOptions?) -> Future<Data>
    func metadata(of: String, on: Container, options: FileOptions?) -> Future<FileMetadata>
    func size(of: String, on: Container, options: FileOptions?) -> Future<Int>
    
    #warning("FIXME: creationDate and modificationDate")
    func timestamp(of: String, on: Container, options: FileOptions?) -> Future<Date>
    func mediaType(of: String, on: Container, options: FileOptions?) -> Future<MediaType>
    
}

public protocol FilesystemWriting {
    
    func write(data: Data, to: String, on: Container, options: FileOptions?) -> Future<()>
    func update(data: Data, to: String, on: Container, options: FileOptions?) -> Future<()>
    func rename(file: String, to: String, on: Container, options: FileOptions?) -> Future<()>
    func copy(file: String, to: String, on: Container, options: FileOptions?) -> Future<()>
    func delete(file: String, on: Container, options: FileOptions?) -> Future<()>
    func delete(directory: String, on: Container, options: FileOptions?) -> Future<()>
    func create(directory: String, on: Container, options: FileOptions?) -> Future<()>
    
}

public typealias FilesystemAdapter = FilesystemReading & FilesystemWriting


extension FilesystemReading {
    
    public func ext(of file: String) -> String? {
        return file.split(separator: ".").last.map(String.init)
    }
    
    public func mediaType(of file: String) -> MediaType? {
        guard let ext = self.ext(of: file) else {
            return nil
        }
        
        return MediaType.fileExtension(ext)
    }
    
    public func mediaType(of file: String, on worker: Container, options: FileOptions?) -> Future<MediaType> {
        guard let ext = file.split(separator: ".").last.map(String.init) else {
            #warning("FIXME: proper error")
            return worker.eventLoop.newFailedFuture(error: FilesystemError.creationFailed)
        }
        
        guard let mediaType = MediaType.fileExtension(ext) else {
            #warning("FIXME: proper error")
            return worker.eventLoop.newFailedFuture(error: FilesystemError.creationFailed)
        }
        
        return worker.eventLoop.newSucceededFuture(result: mediaType)
    }
    
}
