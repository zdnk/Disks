import Foundation

public struct DiskIdentifier: Hashable {
    
    public let identifier: String
    
    public init(_ identifier: String) {
        self.identifier = identifier
    }
    
}

public struct Disk: FilesystemType {
    
    public let identifier: DiskIdentifier
    public let filesystem: FilesystemType
    
    public var adapter: FilesystemAdapter {
        return filesystem.adapter
    }
    
}

extension Disk: FilesystemForwarding {}
