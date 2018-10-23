import Foundation
import Vapor

extension DiskManager.Config: Provider {
    
    public func register(_ services: inout Services) throws {
        services.register(Storage.self) { container in
            return DiskManager(
                config: self,
                on: container
            )
        }
    }

    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
    
}

extension DiskManager: Service {}
