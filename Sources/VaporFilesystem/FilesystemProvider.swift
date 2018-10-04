import Foundation
import Vapor

final class FilesystemProvider: Provider {
    
    let disks: [DiskIdentifier: FilesystemAdapter]
    let defaultDisk: DiskIdentifier
    
    init(disks: [DiskIdentifier: FilesystemAdapter], default: DiskIdentifier) {
        self.disks = disks
        self.defaultDisk = `default`
    }
    
    func register(_ services: inout Services) throws {
        services.register([FilesystemType.self, FilesystemManaging.self]) { container in
            return try FilesystemManager(
                disks: self.disks,
                default: self.defaultDisk,
                on: container
            )
        }
    }
    
    func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
    
    
    
    
}
