import Foundation

extension DiskManager {
    
    public struct Config {
        
        public typealias DiskMap = [DiskIdentifier: FilesystemAdapter]
        
        public let diskMap: DiskMap
        public let `default`: DiskIdentifier
        
        public init(diskMap: DiskMap, default theDefault: DiskIdentifier) throws {
            self.diskMap = diskMap
            self.default = theDefault
            
            guard diskMap.keys.contains(theDefault) else {
                throw Error.defaultNotInDisks
            }
        }
        
    }

}
