import Foundation
import Vapor

extension LocalAdapter: FilesystemContentListing {

    public func listContents(of: String, recursive: Bool, on: Container, options: FileOptions) -> EventLoopFuture<[String]> {
        #warning("TODO: list contents support")
        fatalError("Not implemented.")
    }
    
}
