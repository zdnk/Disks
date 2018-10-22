import Foundation
import Vapor

open class LocalAdapter {
    
    public typealias QueueFactory = () -> DispatchQueue
    
    open class var defaultQueueFactory: QueueFactory {
        return { return DispatchQueue.global(qos: .userInitiated) }
    }
    
    public let fileManager: FileManager
    public let config: Config
    public let queueFactory: QueueFactory
    
    public init(config: Config, fileManager: FileManager = .default, queueFactory: @escaping QueueFactory = LocalAdapter.defaultQueueFactory) {
        self.fileManager = fileManager
        self.config = config
        self.queueFactory = queueFactory
    }
    
    public func absolutePath(to path: String) -> String {
        let prefixed = PathTools.applyPrefix(config.root, to: path)
        return URL(fileURLWithPath: prefixed).absoluteString
    }
    
}
