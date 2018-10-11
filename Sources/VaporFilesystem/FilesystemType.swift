import Foundation
import Vapor

public enum FileVisibility {
    case `public`
    case `private`
}

public typealias FileMetadata = [FileMetadataKey: Any]

public protocol FilesystemType {
    
    func has(file: String, on: Worker, options: FileOptions?) -> Future<Bool>
    func read(file: String, on: Worker, options: FileOptions?) -> Future<Data>
    func listContents(of: String, recursive: Bool, on: Worker, options: FileOptions?) -> Future<[String]>
    func metadata(of: String, on: Worker, options: FileOptions?) -> Future<FileMetadata>
    func size(of: String, on: Worker, options: FileOptions?) -> Future<Int>
    func mimetype(of: String, on: Worker, options: FileOptions?) -> Future<String>
    func timestamp(of: String, on: Worker, options: FileOptions?) -> Future<Date>
    func visibility(of: String, on: Worker, options: FileOptions?) -> Future<FileVisibility>
    func write(data: Data, to: String, on: Worker, options: FileOptions?) -> Future<()>
//    func write(file: String, to: String) -> Future<()>
    func update(data: Data, to: String, on: Worker, options: FileOptions?) -> Future<()>
//    func update(file: String, to: String) -> Future<()>
    func put(data: Data, to: String, on: Worker, options: FileOptions?) -> Future<()>
//    func put(file: String, to: String) -> Future<()>
    func rename(file: String, to: String, on: Worker, options: FileOptions?) -> Future<()>
    func copy(file: String, to: String, on: Worker, options: FileOptions?) -> Future<()>
    func delete(file: String, on: Worker, options: FileOptions?) -> Future<()>
    func delete(directory: String, on: Worker, options: FileOptions?) -> Future<()>
    func create(directory: String, on: Worker, options: FileOptions?) -> Future<()>
    func setVisibility(of: String, to: FileVisibility, on: Worker, options: FileOptions?) -> Future<()>
    
}

//extension FilesystemType {
//    
//    func has(file: String, on: Worker) -> Future<Bool>
//    func read(file: String, on: Worker) -> Future<Data>
//    func listContents(of: String, recursive: Bool, on: Worker) -> Future<[String]>
//    func metadata(of: String, on: Worker) -> Future<FileMetadata>
//    func size(of: String, on: Worker) -> Future<Int>
//    func mimetype(of: String, on: Worker) -> Future<String>
//    func timestamp(of: String, on: Worker) -> Future<Date>
//    func visibility(of: String, on: Worker) -> Future<FileVisibility>
//    func write(data: Data, to: String, on: Worker) -> Future<()>
//    //    func write(file: String, to: String) -> Future<()>
//    func update(data: Data, to: String, on: Worker) -> Future<()>
//    //    func update(file: String, to: String) -> Future<()>
//    func put(data: Data, to: String, on: Worker) -> Future<()>
//    //    func put(file: String, to: String) -> Future<()>
//    func rename(file: String, to: String, on: Worker) -> Future<()>
//    func copy(file: String, to: String, on: Worker) -> Future<()>
//    func delete(file: String, on: Worker) -> Future<()>
//    func delete(directory: String, on: Worker) -> Future<()>
//    func create(directory: String, on: Worker) -> Future<()>
//    func setVisibility(of: String, to: FileVisibility, on: Worker) -> Future<()>
//    
//}
