import Foundation

public enum FilesystemError: Swift.Error {
    
    case notFound
    case alreadyExists
    case unresolvableMediaType
    case invalidPath
    
    case creationFailed
    
    case timestampNotAvailable
    case fileSizeNotAvailable
    
    case cantConstructURLfromPath(String)
    case pathOutsideOfRoot(String)
    case noFileOverrideSupport
    case rootViolation
    
    case listingUnsupported(by: FilesystemAdapting)
    
}
