import Foundation
import Vapor

public protocol FileOverwriteSupporting { }

public protocol FilesystemContentListing {
    
    func listContents(of: String, recursive: Bool, on: Container, options: FileOptions) -> Future<[String]>
    
}

public protocol FilesystemReading {
    
    func has(file: String, on: Container, options: FileOptions) -> Future<Bool>
    func read(file: String, on: Container, options: FileOptions) -> Future<Data>
    func metadata(of: String, on: Container, options: FileOptions) -> Future<FileMetadata>
    func size(of: String, on: Container, options: FileOptions) -> Future<Int>
    #warning("FIXME: creationDate and modificationDate")
    func timestamp(of: String, on: Container, options: FileOptions) -> Future<Date>
    func mediaType(of: String, on: Container, options: FileOptions) -> Future<MediaType>
    
}

public protocol FilesystemWriting {
    
    func write(data: Data, to: String, on: Container, options: FileOptions) -> Future<()>
    func update(data: Data, to: String, on: Container, options: FileOptions) -> Future<()>
    func move(file: String, to: String, on: Container, options: FileOptions) -> Future<()>
    func copy(file: String, to: String, on: Container, options: FileOptions) -> Future<()>
    func delete(file: String, on: Container, options: FileOptions) -> Future<()>
    func delete(directory: String, on: Container, options: FileOptions) -> Future<()>
    func create(directory: String, on: Container, options: FileOptions) -> Future<()>
    
}

public typealias FilesystemAdapter = FilesystemReading & FilesystemWriting


extension FilesystemReading {
    
    public func ext(of file: String) -> String? {
        return file.split(separator: ".").last.map(String.init)
    }
    
    public func mediaType(of file: String) throws -> MediaType {
        guard let ext = self.ext(of: file) else {
            throw FilesystemError.unresolvableMediaType
        }
        
        guard let mediaType = MediaType.fileExtension(ext) else {
            throw FilesystemError.unresolvableMediaType
        }
        
        return mediaType
    }
    
    public func mediaType(of file: String, on worker: Container, options: FileOptions) -> Future<MediaType> {
        do {
            return worker.eventLoop.newSucceededFuture(result: try self.mediaType(of: file))
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }
    
}
