import Foundation

public enum KeyValueStoreError: Swift.Error {
    case castError(from: Any, to: Any)
}

public protocol KeyValueStoring {
    
    associatedtype Key: Hashable
    
    var storage: [Key: Any] { get set }
    
    var keys: [Key] { get }
    
    func has(_ key: Key) -> Bool
    
    mutating func set(key: Key, to value: Any?)
    
    func get<T>(_ key: Key) throws -> T?
    
    func get<T>(_ key: Key, as: T.Type) throws -> T?
    
}

extension KeyValueStoring {
    
    public var keys: [Key] {
        return Array(storage.keys)
    }
    
    public func has(_ key: Key) -> Bool {
        return self.storage.keys.contains(key)
    }
    
    public mutating func set(key: Key, to value: Any?) {
        self.storage[key] = value
    }
    
    public func get<T>(_ key: Key) throws -> T? {
        guard let object = self.storage[key] else {
            return nil
        }
        
        guard let typed = object as? T else {
            let actualType = type(of: object)
            throw KeyValueStoreError.castError(from: actualType, to: T.self)
        }
        
        return typed
    }
    
    public func get<T>(_ key: Key, as: T.Type) throws -> T? {
        let typed: T? = try get(key)
        return typed
    }
    
    public func getOrNil<T>(_ key: Key) -> T? {
        do {
            return try get(key)
        } catch {
            print(error)
            return nil
        }
    }
    
    public func getOrNil<T>(_ key: Key, as: T.Type) -> T? {
        do {
            return try get(key, as: T.self)
        } catch {
            print(error)
            return nil
        }
    }
    
    public func merged<T>(with other: T) throws -> Self where T: KeyValueStoring, T.Key == Key {
        var this = self
        let otherStorage = storage
        this.storage.merge(otherStorage) { _, second in
            return second
        }
        
        return this
    }
    
}
