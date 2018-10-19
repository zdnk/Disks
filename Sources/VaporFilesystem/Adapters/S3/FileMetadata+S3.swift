import Foundation
import S3

public struct S3Metadata {
    
    /// Bucket
    public let bucket: String
    
    /// Region
    public let region: Region
    
    /// Access control for file
    public let access: AccessControlList
    /// Server
    public let server: String?
    
    /// ETag
    public let etag: String?
    
    /// Expiration
    public let expiration: Date?
    
    /// Version ID
    public let versionId: String?
    
    /// Storage class
    public let storageClass: String?
    
}

public extension FileMetadataKey {
    
    internal static let s3Adapter = FileMetadataKey("s3")
    
    public static let s3Bucket = FileMetadataKey("s3.bucket")
    public static let s3Region = FileMetadataKey("s3.region")
    public static let s3Access = FileMetadataKey("s3.access")
    public static let s3Server = FileMetadataKey("s3.server")
    public static let s3ETag = FileMetadataKey("s3.etag")
    public static let s3Expiration = FileMetadataKey("s3.expiration")
    public static let s3VersionId = FileMetadataKey("s3.versionId")
    public static let s3StorageClass = FileMetadataKey("s3.storageClass")
    
}

public extension FileMetadata {
    
    public func s3() throws -> S3Metadata {
        return try S3Metadata(from: self)
    }
    
    public init(with s3: S3Metadata) {
        update(with: s3)
    }
    
    public mutating func update(with s3: S3Metadata) {
        set(key: .s3Adapter, to: true)
        set(key: .s3Bucket, to: s3.bucket)
        set(key: .s3Region, to: s3.region)
        set(key: .s3Access, to: s3.access)
        set(key: .s3Server, to: s3.server)
        set(key: .s3ETag, to: s3.etag)
        set(key: .s3Expiration, to: s3.expiration)
        set(key: .s3VersionId, to: s3.versionId)
        set(key: .s3StorageClass, to: s3.storageClass)
    }
    
}

public extension S3Metadata {
    
    public enum Error: Swift.Error {
        case notFromS3
    }
    
    public init(from meta: FileMetadata) throws {
        guard let isS3 = try meta.get(.s3Adapter, as: Bool.self), isS3 == true else {
            throw Error.notFromS3
        }
        
        self.bucket = try meta.getRequired(.s3Bucket)
        self.region = try meta.getRequired(.s3Region)
        self.access = try meta.getRequired(.s3Access)
        self.server = try meta.get(.s3Server)
        self.etag = try meta.get(.s3ETag)
        self.expiration = try meta.get(.s3Expiration)
        self.versionId = try meta.get(.s3VersionId)
        self.storageClass = try meta.get(.s3StorageClass)
    }
    
}

extension File.Info: FileMetadataConvertible {
    
    public func fileMetadata() throws -> FileMetadata {
        var meta = FileMetadata()
        meta.set(key: .s3Adapter, to: true)
        meta.set(key: .s3Bucket, to: bucket)
        meta.set(key: .s3Region, to: region)
        meta.set(key: .s3Access, to: access)
        meta.set(key: .s3Server, to: server)
        meta.set(key: .s3ETag, to: etag)
        meta.set(key: .s3Expiration, to: expiration)
        meta.set(key: .s3VersionId, to: versionId)
        meta.set(key: .s3StorageClass, to: storageClass)
        
        meta.set(key: .size, to: size)
        meta.set(key: .created, to: created)
        meta.set(key: .modified, to: modified)
        return meta
    }
    
}
