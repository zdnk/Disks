import Foundation

public struct FileOptionKey: Hashable {
    
    public let identifier: String
    
    public init(_ identifier: String) {
        self.identifier = identifier
    }
    
}

public struct FileOptions: KeyValueStoring {
    
    public var storage: [FileOptionKey: Any] = [:]
    
}
