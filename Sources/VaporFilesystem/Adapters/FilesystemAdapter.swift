import Foundation
import Vapor

public protocol FileOverrideSupporting { }

public protocol FilesystemAdapter {
    
    func has(file: String, on: Container, options: FileOptions?) -> Future<Bool>
    func read(file: String, on: Container, options: FileOptions?) -> Future<Data>
    func listContents(of: String, recursive: Bool, on: Container, options: FileOptions?) -> Future<[String]>
    func metadata(of: String, on: Container, options: FileOptions?) -> Future<FileMetadata>
    func size(of: String, on: Container, options: FileOptions?) -> Future<Int>
    func mimetype(of: String, on: Container, options: FileOptions?) -> Future<String>
    func timestamp(of: String, on: Container, options: FileOptions?) -> Future<Date>
//    func visibility(of: String, on: Worker, options: FileOptions?) -> Future<FileVisibility>
    func write(data: Data, to: String, on: Container, options: FileOptions?) -> Future<()>
    func update(data: Data, to: String, on: Container, options: FileOptions?) -> Future<()>
    func rename(file: String, to: String, on: Container, options: FileOptions?) -> Future<()>
    func copy(file: String, to: String, on: Container, options: FileOptions?) -> Future<()>
    func delete(file: String, on: Container, options: FileOptions?) -> Future<()>
    func delete(directory: String, on: Container, options: FileOptions?) -> Future<()>
    func create(directory: String, on: Container, options: FileOptions?) -> Future<()>
//    func setVisibility(of: String, to: FileVisibility, on: Worker, options: FileOptions?) -> Future<()>
    
}
