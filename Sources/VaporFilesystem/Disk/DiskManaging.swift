import Foundation

public protocol DiskManaging {
    
    func use(_: DiskIdentifier) throws -> Disk
    
}
