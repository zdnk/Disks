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
    
    internal func run<F>(file: String, on worker: Container, _ block: (LocationConvertible) throws -> Future<F>) -> Future<F> {
        do {
            return try block(fileLocation(for: file))
                .catchMap { (error) -> F in
                    throw self.map(error: error, file: file)
                }
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }
    
    internal func run<F>(directory: String, on worker: Container, _ block: () throws -> Future<F>) -> Future<F> {
        do {
            return try block()
                .catchMap { (error) -> F in
                    throw self.map(error: error, directory: directory)
            }
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }
    
    internal func map(error: Error, file: String) -> Error {
        guard case S3.Error.badResponse(let response) = error else {
            return error
        }
        
        if response.http.status == .notFound {
            return FilesystemError.fileNotFound(file)
        }
        
        return error
    }
    
    internal func map(error: Error, directory: String) -> Error {
        guard case S3.Error.badResponse(let response) = error else {
            return error
        }
        
        if response.http.status == .notFound {
            return FilesystemError.directoryNotFound(directory)
        }
        
        return error
    }
    
}
