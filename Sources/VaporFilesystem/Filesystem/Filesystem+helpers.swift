import Foundation
import Vapor

extension Filesystem {
    
    public func normalize(path: String) throws -> String {
        var normalized = path.replacingOccurrences(of: "\\", with: "/")
        normalized = normalized.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let url = URL(string: normalized) else {
            throw FilesystemError.cantConstructURLfromPath(path)
        }
        
        var parts: [String] = []
        for component in url.pathComponents {
            switch component {
            case "": fallthrough
            case ".": break
            case "..":
                guard !parts.isEmpty else {
                    throw FilesystemError.pathOutsideOfRoot(path)
                }
                
                parts.removeLast()
            default:
                parts.append(component)
            }
        }
        
        return parts.joined(separator: "/")
    }
    
    public func normalize(path: String, on worker: Container) -> Future<String> {
        do {
            let result = try normalize(path: path)
            return worker.eventLoop.newSucceededFuture(result: result)
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }
    
    public class func applyPathPrefix(_ prefix: String, to path: String) -> String {
        guard let prefixed = URL(string: path, relativeTo: URL(string: prefix)) else {
            fatalError("Cannot create prefixed URL")
        }
        
        return prefixed.absoluteString
    }
    
}
