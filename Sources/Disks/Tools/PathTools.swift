import Foundation

public enum PathTools {
    
    public static func normalize(path: String) throws -> String {
        var normalized = path.replacingOccurrences(of: "\\", with: "/")
        normalized = normalized.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let url = URL(string: normalized) else {
            throw PathError.invalid(path)
        }
        
        var parts: [String] = []
        for component in url.pathComponents {
            switch component {
            case "": fallthrough
            case ".": break
            case "..":
                guard !parts.isEmpty else {
                    throw PathError.outsideOfRoot(path)
                }
                
                parts.removeLast()
            default:
                parts.append(component)
            }
        }
        
        return parts.joined(separator: "/")
    }
    
    public static func normalize(path: String, on worker: Container) -> Future<String> {
        do {
            let result = try normalize(path: path)
            return worker.eventLoop.newSucceededFuture(result: result)
        } catch {
            return worker.eventLoop.newFailedFuture(error: error)
        }
    }
    
    public static func applyPrefix(_ prefix: String, to path: String) throws -> String {
        guard let prefixed = URL(string: path, relativeTo: URL(string: prefix)) else {
            throw PathError.invalid(path)
        }
        
        return prefixed.absoluteString
    }
    
}
