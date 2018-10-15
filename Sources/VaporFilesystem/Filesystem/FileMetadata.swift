import Foundation

public struct FileMetadataKey: Hashable {
    
    public let identifier: String
    
    public init(_ identifier: String) {
        self.identifier = identifier
    }
    
}

public extension FileMetadataKey {
    
    public static var creationDate = FileMetadataKey("FileCreationDate")
    public static var modificationDate = FileMetadataKey("FileModificationDate")
    public static var size = FileMetadataKey("FileSize")
    
}

public struct FileMetadata: KeyValueStoring {
    
    public var storage: [FileMetadataKey: Any] = [:]
    
}

public extension FileMetadata {
    
    var creationDate: Date? {
        get {
            return try! get(.creationDate, as: Date.self)
        }
        set {
            set(key: .creationDate, to: newValue)
        }
    }
    
    var modificationDate: Date? {
        get {
            return try! get(.modificationDate, as: Date.self)
        }
        set {
            set(key: .modificationDate, to: newValue)
        }
    }
    
    var size: Int? {
        get {
            return try! get(.size, as: Int.self)
        }
        set {
            set(key: .size, to: newValue)
        }
    }
    
}
