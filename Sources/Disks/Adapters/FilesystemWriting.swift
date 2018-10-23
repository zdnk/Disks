import Foundation
import Vapor

public protocol FilesystemWriting {
    
    var supportsOverwrite: Bool { get }
    
    func write(data: Data, to: String, on: Container, options: FileOptions) -> Future<()>
    func update(data: Data, to: String, on: Container, options: FileOptions) -> Future<()>
    func move(file: String, to: String, on: Container, options: FileOptions) -> Future<()>
    func copy(file: String, to: String, on: Container, options: FileOptions) -> Future<()>
    func delete(file: String, on: Container, options: FileOptions) -> Future<()>
    func delete(directory: String, on: Container, options: FileOptions) -> Future<()>
    func create(directory: String, on: Container, options: FileOptions) -> Future<()>
    
}
