import Foundation

public protocol FilesystemAdaptable {
    
    var adapter: FilesystemAdapting { get }
    
}
