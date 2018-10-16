import Foundation
@_exported import S3


open class S3Adapter {
    
    public let bucket: String
    public let client: S3
    public let signer: S3Signer
    public let region: Region
    
    #warning("TODO: abstract away S3Signer.Config?")
    #warning("TODO: default config for access and other properties and metadata")
    public init(bucket: String, config: S3Signer.Config) throws {
        self.bucket = bucket
        self.region = config.region
        
        self.signer = try S3Signer(config)
        self.client = try S3(defaultBucket: bucket, signer: self.signer)
    }
    
    open func fileLocation(for path: String) -> File.Location {
        return File.Location(
            path: path,
            bucket: bucket,
            region: region
        )
    }
    
    internal func run<F>(path: String, on worker: Container, _ block: (LocationConvertible) throws -> Future<F>) -> Future<F> {
        do {
            return try block(fileLocation(for: path))
                .catchMap { (error) -> F in
                    throw self.map(error: error, path: path)
                }
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }
    
    internal func map(error: Error, path: String) -> Error {
        guard case S3.Error.badResponse(let response) = error else {
            return error
        }
        
        if response.http.status == .notFound {
            return FilesystemError.notFound
        }
        
        return error
    }

    
}
