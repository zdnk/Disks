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
