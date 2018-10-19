import Foundation

public struct LocalMetadata {
    
    public enum Error: Swift.Error {
        case notFromLocal
    }
    
    public let attributes: [FileAttributeKey: Any]
    
    init(from meta: FileMetadata) throws {
        guard let isLocal = try meta.get(.localAdapter, as: Bool.self), isLocal == true else {
            throw Error.notFromLocal
        }
        
        self.attributes = try meta.getRequired(.localAttributes)
    }
    
}

extension Dictionary: FileMetadataConvertible where Key == FileAttributeKey, Value == Any {
    
    public func fileMetadata() throws -> FileMetadata {
        var meta = FileMetadata()
        meta.set(key: .localAdapter, to: true)
        meta.set(key: .localAttributes, to: self)
        
        meta.set(key: .size, to: self[.size])
        meta.set(key: .created, to: self[.creationDate])
        meta.set(key: .modified, to: self[.modificationDate])
        return meta
    }
    
}

extension FileMetadataKey {
    
    public static let localAdapter = FileMetadataKey("local")
    public static let localAttributes = FileMetadataKey("local.attributes")
    
}

extension FileMetadata {
    
    public func local() throws -> LocalMetadata {
        return try LocalMetadata(from: self)
    }
    
}
