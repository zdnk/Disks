import Foundation

struct DiskIdentifier: Hashable {
    let identifier: String
}

protocol FilesystemManaging: FilesystemType {
    
    var disks: [DiskIdentifier: FilesystemAdapter] { get }
    
    func use(_: DiskIdentifier) throws -> FilesystemType
    
}
