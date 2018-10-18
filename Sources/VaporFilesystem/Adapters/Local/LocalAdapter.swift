import Foundation
import Vapor

open class LocalAdapter {
    
    public typealias QueueFactory = () -> DispatchQueue
    
    open class var defaultQueueFactory: QueueFactory {
        return { return DispatchQueue.global(qos: .userInitiated) }
    }
    
    public let fileManager: FileManager
    public let root: String
    
    public let queueFactory: QueueFactory
    
    #warning("TODO: Default attributes like file permissions etc.")
    public init(fileManager: FileManager = .default, root: String, queueFactory: @escaping QueueFactory = LocalAdapter.defaultQueueFactory) {
        self.fileManager = fileManager
        self.root = root
        self.queueFactory = queueFactory
    }
    
    public func absolutePath(to path: String) -> String {
        let prefixed = Filesystem.applyPathPrefix(self.root, to: path)
        return URL(fileURLWithPath: prefixed).absoluteString
    }
    
}
