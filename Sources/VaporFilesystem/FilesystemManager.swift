import Foundation
import Vapor

open class FilesystemManager: Filesystem {
    
    public enum Error: Swift.Error {
        case defaultNotInDisks
        case diskNotRegistered(DiskIdentifier)
    }
    
    public let disks: [DiskIdentifier: FilesystemAdapter]
    public let `default`: DiskIdentifier
    
    public init(disks: [DiskIdentifier: FilesystemAdapter], default theDefault: DiskIdentifier, on worker: Container) throws {
        self.disks = disks
        self.default = theDefault
        
        guard disks.keys.contains(theDefault) else {
            throw Error.defaultNotInDisks
        }
        
        let defaultAdapter = disks[theDefault]!
        super.init(adapter: defaultAdapter, on: worker)
    }
    
}

extension FilesystemManager: FilesystemManaging {
    
    open func use(_ id: DiskIdentifier) throws -> FilesystemType {
        guard let adapter = disks[id] else {
            throw Error.diskNotRegistered(id)
        }
        
        return Filesystem(adapter: adapter, on: worker)
    }
    
}

extension FilesystemManager: Service {}
