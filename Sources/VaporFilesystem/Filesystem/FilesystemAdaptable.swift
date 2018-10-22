import Foundation

public protocol FilesystemAdaptable {
    
    var adapter: FilesystemAdapter { get }
    
}
