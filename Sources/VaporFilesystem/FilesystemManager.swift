import Foundation
import Vapor

class FilesystemManager: Filesystem {
    
    let disks: [DiskIdentifier: FilesystemAdapter]
    let `default`: DiskIdentifier
    
    let worker: Worker
    
    init(disks: [DiskIdentifier: FilesystemAdapter], default: DiskIdentifier, on worker: Worker) throws {
        self.disks = disks
        self.default = `default`
        self.worker = worker
        
        #warning("TODO: throw error if it is not present")
        let defaultAdapter = disks[`default`]!
        super.init(adapter: defaultAdapter)
    }
    
}

extension FilesystemManager: FilesystemManaging {
    
    func use(_ id: DiskIdentifier) throws -> FilesystemType {
        #warning("TODO: throw error if it is not present")
        let adapter = disks[id]!
        return Filesystem(adapter: adapter)
    }
    
}

extension FilesystemManager: Service {}
