import Foundation
import S3

extension S3Adapter {
    
    internal func fileLocation(for path: String) -> File.Location {
        return File.Location(
            path: path,
            bucket: bucket,
            region: config.region
        )
    }
    
    internal func run<F>(path: String, on worker: Container, _ block: (LocationConvertible) throws -> Future<F>) -> Future<F> {
        do {
            return try block(fileLocation(for: path))
                .catchMap { (error) -> F in
                    if let s3Error = error as? S3.Error {
                        throw self.map(error: s3Error, path: path)
                    }
                    
                    throw error
            }
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }
    
    internal func fileUpload(data: Data, to file: LocationConvertible) throws -> File.Upload {
        #warning("FIXME: access overriding")
        #warning("FIXME: Region is not passed anywhere to upload!")
        return File.Upload(
            data: data,
            bucket: file.bucket,
            destination: file.path,
            access: self.config.defaultAccess,
            mime: try self.mediaType(of: file.path).description
        )
    }
    
    private func map(error: S3.Error, path: String) -> Error {
        guard case S3.Error.badResponse(let response) = error else {
            return error
        }
        
        if response.http.status == .notFound {
            return FilesystemError.notFound
        }
        
        return error
    }
    
}
