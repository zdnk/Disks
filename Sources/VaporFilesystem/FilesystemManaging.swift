import Foundation

public struct DiskIdentifier: Hashable {
    
    public let identifier: String
    
    public init(_ identifier: String) {
        self.identifier = identifier
    }
    
}

public protocol FilesystemManaging: FilesystemType {
    
    var disks: [DiskIdentifier: FilesystemAdapter] { get }
    
    func use(_: DiskIdentifier) throws -> FilesystemType
    
}
