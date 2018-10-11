import Foundation
import Vapor

public final class FilesystemProvider: Provider {
    
    public let disks: [DiskIdentifier: FilesystemAdapter]
    public let defaultDisk: DiskIdentifier
    
    public init(disks: [DiskIdentifier: FilesystemAdapter], default: DiskIdentifier) {
        self.disks = disks
        self.defaultDisk = `default`
    }
    
    public func register(_ services: inout Services) throws {
        services.register([FilesystemType.self, FilesystemManaging.self]) { container in
            return try FilesystemManager(
                disks: self.disks,
                default: self.defaultDisk,
                on: container
            )
        }
    }
    
    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
    
    
    
    
}
