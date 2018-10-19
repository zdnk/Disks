import Foundation

public protocol FileOptionsConvertible {
    
    func fileOptions() throws -> FileOptions
    
}

public struct FileOptionKey: Hashable {
    
    public let identifier: String
    
    public init(_ identifier: String) {
        self.identifier = identifier
    }
    
}

public struct FileOptions: KeyValueStoring {
    
    public var storage: [FileOptionKey: Any] = [:]
    
    public static var empty: FileOptions {
        return FileOptions()
    }
    
}

extension FileOptions: FileOptionsConvertible {
    
    public func fileOptions() throws -> FileOptions {
        return self
    }
    
}
