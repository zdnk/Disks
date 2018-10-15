import Foundation

public enum FilesystemError: Swift.Error {
    
    case fileNotFound(String)
    case creationFailed
    
    case timestampNotAvailable
    case fileSizeNotAvailable
    
    case cantConstructURLfromPath(String)
    case pathOutsideOfRoot(String)
    case noFileOverrideSupport
    case rootViolation
    
    case listingUnsupported(by: FilesystemAdapter)
    
}
