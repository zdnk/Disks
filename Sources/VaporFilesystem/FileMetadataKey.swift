import Foundation

struct FileMetadataKey: Hashable {
    
    let identifier: String
    
    init(_ identifier: String) {
        self.identifier = identifier
    }
    
}

extension FileMetadataKey {
    
    static var creationDate = FileMetadataKey(identifier: "FileCreationDate")
    static var modificationDate = FileMetadataKey(identifier: "FileModificationDate")
    static var size = FileMetadataKey(identifier: "FileSize")
    
}
