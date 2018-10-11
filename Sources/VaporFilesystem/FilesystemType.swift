import Foundation
import Vapor

public enum FileVisibility {
    case `public`
    case `private`
}

public typealias FileMetadata = [FileMetadataKey: Any]

public protocol FilesystemType {
    
    func has(file: String, options: FileOptions?) -> Future<Bool>
    func read(file: String, options: FileOptions?) -> Future<Data>
    func listContents(of: String, recursive: Bool, options: FileOptions?) -> Future<[String]>
    func metadata(of: String, options: FileOptions?) -> Future<FileMetadata>
    func size(of: String, options: FileOptions?) -> Future<Int>
    func mimetype(of: String, options: FileOptions?) -> Future<String>
    func timestamp(of: String, options: FileOptions?) -> Future<Date>
//    func visibility(of: String, options: FileOptions?) -> Future<FileVisibility>
    func write(data: Data, to: String, options: FileOptions?) -> Future<()>
//    func write(file: String, to: String) -> Future<()>
    func update(data: Data, to: String, options: FileOptions?) -> Future<()>
//    func update(file: String, to: String) -> Future<()>
    func put(data: Data, to: String, options: FileOptions?) -> Future<()>
//    func put(file: String, to: String) -> Future<()>
    func rename(file: String, to: String, options: FileOptions?) -> Future<()>
    func copy(file: String, to: String, options: FileOptions?) -> Future<()>
    func delete(file: String, options: FileOptions?) -> Future<()>
    func delete(directory: String, options: FileOptions?) -> Future<()>
    func create(directory: String, options: FileOptions?) -> Future<()>
//    func setVisibility(of: String, to: FileVisibility, options: FileOptions?) -> Future<()>
    
}

//extension FilesystemType {
//    
//    func has(file: String) -> Future<Bool>
//    func read(file: String) -> Future<Data>
//    func listContents(of: String, recursive: Bool) -> Future<[String]>
//    func metadata(of: String) -> Future<FileMetadata>
//    func size(of: String) -> Future<Int>
//    func mimetype(of: String) -> Future<String>
//    func timestamp(of: String) -> Future<Date>
//    func visibility(of: String) -> Future<FileVisibility>
//    func write(data: Data, to: String) -> Future<()>
//    //    func write(file: String, to: String) -> Future<()>
//    func update(data: Data, to: String) -> Future<()>
//    //    func update(file: String, to: String) -> Future<()>
//    func put(data: Data, to: String) -> Future<()>
//    //    func put(file: String, to: String) -> Future<()>
//    func rename(file: String, to: String) -> Future<()>
//    func copy(file: String, to: String) -> Future<()>
//    func delete(file: String) -> Future<()>
//    func delete(directory: String) -> Future<()>
//    func create(directory: String) -> Future<()>
//    func setVisibility(of: String, to: FileVisibility) -> Future<()>
//    
//}
