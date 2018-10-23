import Foundation

public struct DiskIdentifier: Identifiable, Hashable {
    
    public let identifier: String
    
    public init(_ identifier: String) {
        self.identifier = identifier
    }
    
}
