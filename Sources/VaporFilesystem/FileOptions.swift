import Foundation

struct FileOptionKey: Hashable {
    
    let identifier: String
    
    init(_ identifier: String) {
        self.identifier = identifier
    }
    
}

struct FileOptions {
    
    private(set) var storage: [FileOptionKey: Any] = [:]
    
    var keys: [FileOptionKey] {
        return Array(storage.keys)
    }
    
    func has(_ key: FileOptionKey) -> Bool {
        return self.storage.keys.contains(key)
    }
    
    mutating func set(key: FileOptionKey, to value: Any?) {
        self.storage[key] = value
    }
    
    func get<T>(_ key: FileOptionKey) throws -> T? {
        guard let object = self.storage[key] else {
            return nil
        }
        
        guard let typed = object as? T else {
            let actualType = type(of: object)
            #warning("TODO: Throw error")
            return nil
        }
        
        return typed
    }
    
    func get<T>(_ key: FileOptionKey, as: T.Type) throws -> T? {
        let typed: T? = try get(key)
        return typed
    }
    
}
