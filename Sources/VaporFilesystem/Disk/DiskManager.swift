import Foundation
import Vapor

open class DiskManager: FilesystemOperating {
    
    public enum Error: Swift.Error {
        case defaultNotInDisks
        case diskNotRegistered(DiskIdentifier)
    }
    
    public struct Config {
        typealias DiskMap = [DiskIdentifier: FilesystemAdapter]
        let diskMap: DiskMap
        let `default`: DiskIdentifier
        
        init(diskMap: DiskMap, default theDefault: DiskIdentifier) throws {
            self.diskMap = diskMap
            self.default = theDefault
            
            guard diskMap.keys.contains(theDefault) else {
                throw Error.defaultNotInDisks
            }
        }
    }
    
    public let config: Config
    public let container: Container
    
    public var defaultDisk: Disk {
        return try! use(config.default)
    }
    
    public init(config: Config, on worker: Container) {
        self.config = config
        self.container = worker
    }
    
}

extension DiskManager: FilesystemForwarding {
    
    var filesystem: FilesystemType {
        return defaultDisk
    }
    
}

extension DiskManager: DiskManaging {
    
    open func use(_ id: DiskIdentifier) throws -> Disk {
        guard let adapter = config.diskMap[id] else {
            throw Error.diskNotRegistered(id)
        }
        
        return Disk(
            identifier: id,
            filesystem: Filesystem(adapter: adapter, on: container)
        )
    }
    
}

extension DiskManager: Service {}
