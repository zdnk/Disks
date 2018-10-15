import Foundation
import Vapor

open class LocalAdapter {
    
    public let fileManager: FileManager
    public let root: String
    
    public init(fileManager: FileManager = .default, root: String) {
        self.fileManager = fileManager
        self.root = root
    }
    
    public func applyPathPrefix(to path: String) -> String {
        let prefixed = Filesystem.applyPathPrefix(self.root, to: path)
        return URL(fileURLWithPath: prefixed).absoluteString
    }
    
}
