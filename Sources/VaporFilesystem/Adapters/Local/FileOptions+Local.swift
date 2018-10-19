import Foundation

public struct LocalFileOptions: FileOptionsConvertible {
    
    public let attributes: [FileAttributeKey: Any]?
    
    public init(attributes: [FileAttributeKey: Any]? = nil) {
        self.attributes = attributes
    }
    
    public init(from options: FileOptions) throws {
        self.attributes = try options.get(.localAttributes, as: [FileAttributeKey: Any].self)
    }
    
    public func fileOptions() throws -> FileOptions {
        var options = FileOptions()
        options.set(key: .localAttributes, to: attributes)
        return options
    }
    
}

extension FileOptionKey {
    
    public static let localAttributes = FileOptionKey("local.attributes")
    
}

extension FileOptions {
    
    public var local: LocalFileOptions? {
        return try? LocalFileOptions(from: self)
    }
    
}
