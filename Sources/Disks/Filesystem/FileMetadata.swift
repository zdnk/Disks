import Foundation

public protocol FileMetadataConvertible {
    
    func fileMetadata() throws -> FileMetadata
    
}

public struct FileMetadataKey: Hashable, Identifiable {
    
    public let identifier: String
    
    public init(_ identifier: String) {
        self.identifier = identifier
    }
    
}

public extension FileMetadataKey {
    
    public static let created = FileMetadataKey("createdDate")
    public static let modified = FileMetadataKey("modifiedDate")
    public static let size = FileMetadataKey("size")
    public static let mime = FileMetadataKey("mime")
    
}

public struct FileMetadata: KeyValueStoring, FileMetadataConvertible {
    
    public var storage: [FileMetadataKey: Any] = [:]
    
    public func fileMetadata() throws -> FileMetadata {
        return self
    }
    
}

public extension FileMetadata {
    
    var creationDate: Date? {
        get {
            return getOrNil(.created, as: Date.self)
        }
        set {
            set(key: .created, to: newValue)
        }
    }
    
    var modified: Date? {
        get {
            return getOrNil(.modified, as: Date.self)
        }
        set {
            set(key: .modified, to: newValue)
        }
    }
    
    var size: Int? {
        get {
            return getOrNil(.size, as: Int.self)
        }
        set {
            set(key: .size, to: newValue)
        }
    }
    
    var mime: String? {
        get {
            return getOrNil(.mime, as: String.self)
        }
        set {
            set(key: .mime, to: newValue)
        }
    }
    
}
