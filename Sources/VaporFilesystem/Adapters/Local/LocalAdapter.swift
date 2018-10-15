import Foundation
import Vapor

open class LocalAdapter {
    
    public let fileManager: FileManager
    public let root: String
    public let queue: DispatchQueue
    
    
    public init(fileManager: FileManager = .default, root: String, queue: DispatchQueue? = nil) {
        self.fileManager = fileManager
        self.root = root
        self.queue = queue ?? DispatchQueue(
            label: "com.zdnkt.VaporFilesystem.LocalAdapter",
            qos: .userInitiated,
            attributes: .concurrent,
            autoreleaseFrequency: .inherit,
            target: nil
        )
    }
    
    public func applyPathPrefix(to path: String) -> String {
        let prefixed = Filesystem.applyPathPrefix(self.root, to: path)
        return URL(fileURLWithPath: prefixed).absoluteString
    }
    
    internal func run<T>(on worker: Container, _ closure: @escaping () throws -> T) -> Future<T> {
        let promise = worker.eventLoop.newPromise(T.self)
        queue.async {
            do {
                let result = try closure()
                promise.succeed(result: result)
            } catch {
                promise.fail(error: error)
            }
        }
        return promise.futureResult
    }
    
}
