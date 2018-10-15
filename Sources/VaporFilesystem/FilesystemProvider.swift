import Foundation
import Vapor

open class FilesystemProvider: Provider {
    
    public let disks: [DiskIdentifier: FilesystemAdapter]
    public let defaultDisk: DiskIdentifier
    
    public init(disks: [DiskIdentifier: FilesystemAdapter], default: DiskIdentifier) {
        self.disks = disks
        self.defaultDisk = `default`
    }
    
    open func register(_ services: inout Services) throws {
        services.register([FilesystemType.self, FilesystemManaging.self]) { container in
            return try FilesystemManager(
                disks: self.disks,
                default: self.defaultDisk,
                on: container
            )
        }
    }
    
    open func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
    
    
    
    
}
