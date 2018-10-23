import Foundation
import Vapor

public struct Filesystem: FilesystemType {
    
    public let adapter: FilesystemAdapting
    public let worker: Container
    
    public init(adapter: FilesystemAdapting, on worker: Container) {
        self.adapter = adapter
        self.worker = worker
    }
    
}
