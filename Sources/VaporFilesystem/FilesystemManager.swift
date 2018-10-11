import Foundation
import Vapor

public class FilesystemManager: Filesystem {
    
    public let disks: [DiskIdentifier: FilesystemAdapter]
    public let `default`: DiskIdentifier
    
    public init(disks: [DiskIdentifier: FilesystemAdapter], default: DiskIdentifier, on worker: Worker) throws {
        self.disks = disks
        self.default = `default`
        
        #warning("TODO: throw error if it is not present")
        let defaultAdapter = disks[`default`]!
        super.init(adapter: defaultAdapter, on: worker)
    }
    
}

extension FilesystemManager: FilesystemManaging {
    
    public func use(_ id: DiskIdentifier) throws -> FilesystemType {
        #warning("TODO: throw error if it is not present")
        let adapter = disks[id]!
        return Filesystem(adapter: adapter, on: worker)
    }
    
}

extension FilesystemManager: Service {}
