import Foundation

public struct Disk: FilesystemType {
    
    public let identifier: DiskIdentifier
    public let filesystem: FilesystemType
    
    public var adapter: FilesystemAdapting {
        return filesystem.adapter
    }
    
}

extension Disk: FilesystemForwarding {}
