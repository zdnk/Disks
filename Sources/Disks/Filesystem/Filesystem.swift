import Foundation
import Vapor

public struct Filesystem: FilesystemType {
    
    public let adapter: FilesystemAdapter
    public let worker: Container
    
    public init(adapter: FilesystemAdapter, on worker: Container) {
        self.adapter = adapter
        self.worker = worker
    }
    
}
