import Foundation
import S3

public struct S3FileOptions: FileOptionsConvertible {
    
    public let access: AccessControlList?
    public let mime: String?
    
    public init(access: AccessControlList? = nil, mime: String? = nil) {
        self.access = access
        self.mime = mime
    }
    
    public init(from options: FileOptions) throws {
        self.access = try options.get(.s3Access, as: AccessControlList.self)
        self.mime = try options.get(.s3Mime, as: String.self)
    }
    
    public func fileOptions() throws -> FileOptions {
        var options = FileOptions()
        options.set(key: .s3Access, to: access)
        options.set(key: .s3Mime, to: mime)
        return options
    }
    
}

extension FileOptionKey {
    
    public static let s3Access = FileOptionKey("s3.access")
    public static let s3Mime = FileOptionKey("s3.mime")
    
}

extension FileOptions {
    
    public func s3() throws -> S3FileOptions {
        return try S3FileOptions(from: self)
    }
    
}
