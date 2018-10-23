import Foundation
import Vapor

public protocol FilesystemContentListing {
    
    func listContents(of: String, recursive: Bool, on: Container, options: FileOptions) -> Future<[String]>
    
}
