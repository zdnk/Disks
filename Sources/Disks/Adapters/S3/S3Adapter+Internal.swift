import Foundation
import S3

extension S3Adapter {
    
    internal func map(error: S3.Error, path: String) -> Error {
        guard case S3.Error.badResponse(let response) = error else {
            return error
        }
        
        if response.http.status == .notFound {
            return FilesystemError.notFound(path)
        }
        
        return error
    }
    
}
