import Foundation
import Vapor

public protocol FilesystemReading {
    
    func has(file: String, on: Container, options: FileOptions) -> Future<Bool>
    func read(file: String, on: Container, options: FileOptions) -> Future<Data>
    func metadata(of: String, on: Container, options: FileOptions) -> Future<FileMetadataConvertible>
    func size(of: String, on: Container, options: FileOptions) -> Future<Int?>
    func mediaType(of: String, on: Container, options: FileOptions) -> Future<MediaType>
    
}

extension FilesystemReading {
    
    public func ext(of file: String) -> String? {
        return file.split(separator: ".").last.map(String.init)
    }
    
    public func mediaType(of file: String) throws -> MediaType {
        guard let ext = self.ext(of: file) else {
            throw MediaTypeError.unresolvable(file)
        }
        
        guard let mediaType = MediaType.fileExtension(ext) else {
            throw MediaTypeError.unresolvable(file)
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
