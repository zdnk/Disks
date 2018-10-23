import Foundation

public enum FilesystemError: Swift.Error {
    
    case notFound(String)
    case alreadyExists(String)
    
    case creationFailed(String)
    
    case fileOverrideUnsupported(by: FilesystemAdapting)
    
    case listingUnsupported(by: FilesystemAdapting)
    
}
