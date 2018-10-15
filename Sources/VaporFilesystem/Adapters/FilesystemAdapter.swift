import Foundation
import Vapor

public protocol FileOverwriteSupporting { }

public protocol FilesystemContentListing {
    
    func listContents(of: String, recursive: Bool, on: Container, options: FileOptions?) -> Future<[String]>
    
}

public protocol FilesystemReading {
    
    func has(file: String, on: Container, options: FileOptions?) -> Future<Bool>
    func read(file: String, on: Container, options: FileOptions?) -> Future<Data>
    func metadata(of: String, on: Container, options: FileOptions?) -> Future<FileMetadata>
    func size(of: String, on: Container, options: FileOptions?) -> Future<Int>
    func timestamp(of: String, on: Container, options: FileOptions?) -> Future<Date>
    
}

public protocol FilesystemWriting {
    
    func write(data: Data, to: String, on: Container, options: FileOptions?) -> Future<()>
    func update(data: Data, to: String, on: Container, options: FileOptions?) -> Future<()>
    func rename(file: String, to: String, on: Container, options: FileOptions?) -> Future<()>
    func copy(file: String, to: String, on: Container, options: FileOptions?) -> Future<()>
    func delete(file: String, on: Container, options: FileOptions?) -> Future<()>
    func delete(directory: String, on: Container, options: FileOptions?) -> Future<()>
    func create(directory: String, on: Container, options: FileOptions?) -> Future<()>
    
}

public typealias FilesystemAdapter = FilesystemReading & FilesystemWriting
