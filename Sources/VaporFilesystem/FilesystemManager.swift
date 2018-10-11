import Foundation
import Vapor

public class FilesystemManager: Filesystem {
    
    public let disks: [DiskIdentifier: FilesystemAdapter]
    public let `default`: DiskIdentifier
    
    public let worker: Worker
    
    public init(disks: [DiskIdentifier: FilesystemAdapter], default: DiskIdentifier, on worker: Worker) throws {
        self.disks = disks
        self.default = `default`
        self.worker = worker
        
        #warning("TODO: throw error if it is not present")
        let defaultAdapter = disks[`default`]!
        super.init(adapter: defaultAdapter)
    }
    
}

extension FilesystemManager: FilesystemManaging {
    
    public func use(_ id: DiskIdentifier) throws -> FilesystemType {
        #warning("TODO: throw error if it is not present")
        let adapter = disks[id]!
        return Filesystem(adapter: adapter)
    }
    
}

extension FilesystemManager: Service {}
