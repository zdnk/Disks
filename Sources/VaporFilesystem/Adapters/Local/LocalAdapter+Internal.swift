import Foundation

extension LocalAdapter {
    
    internal func run<T>(on worker: Container, _ closure: @escaping () throws -> T) -> Future<T> {
        let promise = worker.eventLoop.newPromise(T.self)
        let queue = queueFactory()
        
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
