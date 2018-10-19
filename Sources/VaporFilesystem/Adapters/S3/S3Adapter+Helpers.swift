import Foundation
import S3

extension S3Adapter {
    
    public func fileLocation(for path: String) -> File.Location {
        return File.Location(
            path: path,
            bucket: bucket,
            region: config.region
        )
    }
    
    public func fileUpload(data: Data, to file: LocationConvertible, options: S3FileOptions) throws -> File.Upload {
        #warning("FIXME: Region is not passed anywhere to upload!")
        return File.Upload(
            data: data,
            bucket: file.bucket,
            destination: file.path,
            access: options.access ?? self.config.defaultAccess,
            mime: try options.mime ?? self.mediaType(of: file.path).description
        )
    }
    
    public func run<F>(path: String, on worker: Container, _ block: (LocationConvertible) throws -> Future<F>) -> Future<F> {
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
    
}
