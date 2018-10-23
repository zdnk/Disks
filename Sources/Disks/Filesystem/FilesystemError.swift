import Foundation

public enum MediaTypeError: Swift.Error {
    case unresolvable(String)
}

public enum FilesystemError: Swift.Error {
    
    case notFound(String)
    case alreadyExists(String)
    
    case creationFailed(String)
    
    case fileOverrideUnsupported(by: FilesystemAdapting)
    
    case listingUnsupported(by: FilesystemAdapting)
    
}
