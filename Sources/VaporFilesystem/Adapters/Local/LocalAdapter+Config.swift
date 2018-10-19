import Foundation

extension LocalAdapter {
    
    public struct Config {
        
        public let root: String
        public let defaultAttributes: [FileAttributeKey: Any]?
        
        public init(root: String, defaultAttributes: [FileAttributeKey: Any]? = nil) {
            self.root = root
            self.defaultAttributes = defaultAttributes
        }
        
    }
    
}
