import Foundation

public struct FileOptionKey: Hashable {
    
    public let identifier: String
    
    public init(_ identifier: String) {
        self.identifier = identifier
    }
    
}

public struct FileOptions {
    
    public enum Error: Swift.Error {
        case castError(from: Any, to: Any)
    }
    
    public private(set) var storage: [FileOptionKey: Any] = [:]
    
    public var keys: [FileOptionKey] {
        return Array(storage.keys)
    }
    
    public func has(_ key: FileOptionKey) -> Bool {
        return self.storage.keys.contains(key)
    }
    
    public mutating func set(key: FileOptionKey, to value: Any?) {
        self.storage[key] = value
    }
    
    public func get<T>(_ key: FileOptionKey) throws -> T? {
        guard let object = self.storage[key] else {
            return nil
        }
        
        guard let typed = object as? T else {
            let actualType = type(of: object)
            throw Error.castError(from: actualType, to: T.self)
        }
        
        return typed
    }
    
    public func get<T>(_ key: FileOptionKey, as: T.Type) throws -> T? {
        let typed: T? = try get(key)
        return typed
    }
    
}
